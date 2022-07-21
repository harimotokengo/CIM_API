module Api
  module V1
    class ClientJoinsController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      # クライアント参加者管理
      # client_joinしてるuserおよびofficeの一覧
      def index
        @client = Client.active.find(params[:client_id])
        return response_forbidden unless correct_user
        data = @client.index_client_join_data
        render json: {status: 200, data: data}
      end

      # クライアント招待
      # URL発行ボタン
      def create_token
        @client = Client.active.find(params[:client_id])
        return response_forbidden unless correct_user
        @invite_url = @client.invite_urls.create(
          admin: params[:admin],
          user_id: current_user.id,
          token: SecureRandom.urlsafe_base64(16),
          limit_date: Time.now.tomorrow,
          join: false
        )
        render json: { status: 200, message: "招待URLを発行しました"}
      end

      # クライアント招待
      # URL表示画面で招待URLを表示する
      def get_invite_url
        @client = Client.active.find(params[:client_id])
        return response_forbidden unless correct_user
        @invite_url = current_user.invite_urls.last
        token_url = @invite_url.set_token_url
        render json: {status: 200, data: token_url}
      end

      # 案件参加者のアクション
      # 案件参加画面のsubmitボタン
      def create
        @client = Client.active.find(params[:client_id])
        @invite_url = InviteUrl.find(params[:invite_url_id])
        @client_join = @client.client_joins.new(
          belong_side_id: params[:belong_side_id],
          admin: @invite_url.admin)
        return response_forbidden unless correct_user
        return response_bad_request unless @invite_url.deadline_check && @invite_url.accessed_check
        @client_join.set_joiner(current_user)
        @invite_url.update(join: true)
        
        if @client_join.save
          render json: { status: 200, message: "参加しました"}
        else
          render status: 400, json: { status: 400, message: '参加出来ません。入力必須項目を確認してください', errors: @client_join.errors }
        end
      end

      # indexのmatter_joinの管理者権限の更新
      def update
        @client = Client.active.find(params[:client_id])
        @client_join = ClientJoin.find(params[:id])
        return response_forbidden unless correct_user
        if params[:client_join][:admin] == 'false'
          return response_bad_request unless @client.minimum_required_administrator_check(@client_join)
        end
        
        if @client_join.update(admin: params[:client_join][:admin])
          render json: { status: 200, message: "更新しました"}
        else
          render json: { status: 400, message: '更新出来ません', errors: @client_join.errors }
        end
      end

      # indexのmatter_joinを削除
      def destroy
        @client = Client.active.find(params[:client_id])
        @client_join = ClientJoin.find(params[:id])
        return response_forbidden unless correct_user
        return response_bad_request unless @client.minimum_required_administrator_check(@client_join)
        @client_join.destroy
        render json: { status: 200, message: "削除しました"}
      end

      private

      def correct_user
        if action_name == 'index'
          return true if @client.join_check(current_user)
        elsif  action_name == 'create'
          return true if @client_join.joining_check(current_user)
        else
          return true if  @client.admin_check(current_user) && current_user.admin_check
        end
      end
    end
  end
end