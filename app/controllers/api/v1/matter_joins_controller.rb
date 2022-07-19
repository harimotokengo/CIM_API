module Api
  module V1
    class MatterJoinsController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      # matter_joinしてるuserおよびofficeの一覧
      def index
        @matter = Matter.active.find(params[:matter_id])
        return response_forbidden unless correct_user
        data = @matter.index_matter_join_data
        render json: {status: 200, data: data}
      end

      # URL発行ボタン
      def create_token
        @matter = Matter.active.find(params[:matter_id])
        return response_forbidden unless correct_user
        @invite_url = @matter.invite_urls.create(
          admin: params[:admin],
          user_id: current_user.id,
          token: SecureRandom.urlsafe_base64(16),
          limit_date: Time.now.tomorrow,
          join: false
        )
        render json: { status: 200, message: "招待URLを発行しました"}
      end

      # URL表示画面で招待URLを表示する
      def get_invite_url
        @matter = Matter.active.find(params[:matter_id])
        return response_forbidden unless correct_user
        @invite_url = current_user.invite_urls.last
        token_url = @invite_url.set_token_url
        render json: {status: 200, data: token_url}
      end

      # 案件参加画面のsubmitボタン
      def create
        @matter = Matter.active.find(params[:matter_id])
        @invite_url = InviteUrl.find(params[:invite_url_id])
        @invite_url.update(join: true)
        @matter_join = @matter.matter_joins.new(
          belong_side_id: params[:belong_side_id],
          admin: @invite_url.admin)
        @matter_join.set_parent
        return response_forbidden unless correct_user
        if @matter_join.save
          render json: { status: 200, message: "参加しました"}
        else
          render status: 400, json: { status: 400, message: '参加出来ません。入力必須項目を確認してください', errors: @matter_join.errors }
        end
      end

      # indexのmatter_joinの管理者権限の更新
      def update
        @matter = Matter.active.find(params[:matter_id])
        @matter_join = MatterJoin.find(params[:id])
        return response_forbidden unless correct_user
        if params[:matter_join][:admin] == false
          return response_bad_request if minimum_required_administrator_check(@matter_join)
        end
        
        if @matter_join.update(admin: params[:matter_join][:admin])
          render json: { status: 200, message: "更新しました"}
        else
          render json: { status: 400, message: '更新出来ません', errors: @matter_join.errors }
        end
      end

      # indexのmatter_joinを削除
      def destroy
        @matter = Matter.active.find(params[:matter_id])
        @matter_join = MatterJoin.find(params[:id])
        return response_forbidden unless correct_user
        return response_bad_request if minimum_required_administrator_check(@matter_join)
        @matter_join.destroy
        render json: { status: 200, message: "削除しました"}
      end

      private

      def correct_user
        if action_name == 'index'
          return true if @matter.join_check(current_user) || @matter.client.join_check(current_user)
        elsif  action_name == 'create'
          return true if @matter.joinable_check(current_user, @matter_join)
        else
          if @client.admin_check(current_user) || @matter.admin_check(current_user)
            return true if current_user.admin_check
          end
        end
      end
    end
  end
end