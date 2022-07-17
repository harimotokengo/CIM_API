module Api
  module V1
    class MatterJoinsController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      def new
        @matter_join = MatterJoin.new
        return unless params[:invite_url].present?

        @invite_url = InviteUrl.find(params[:invite_url])
        @token_url = if Rails.env.development?
                      "http://localhost:3000/invite_urls/#{@invite_url.id}?tk=" + @invite_url.token
                    else
                      "https://www.mrcim.com/invite_urls/#{@invite_url.id}?tk=" + @invite_url.token
                    end
      end

      def create
        @matter = Matter.active.find(params[:matter_id])
        @invite_url = InviteUrl.find(params[:invite_url_id])
        @invite_url.update(join: true)
        @matter_join = @matter.matter_joins.new(
          belong_side_id: params[:belong_side_id],
          admin: @invite_url.admin)
        if  @matter_join.belon_side_id == '組織'
          @matter_join.office_id = current_user.belonging_office.id
        else
          @matter_join.user_id = current_user.id
        end
        
        if @matter_join.save
          render json: { status: 200, message: "参加しました"}
        else
          render status: 400, json: { status: 400, message: '参加出来ません。入力必須項目を確認してください', errors: @matter_join.errors }
        end
      end

      def update
        @matter = Matter.active.find(params[:matter_id])
        return response_forbidden unless correct_user
        @matter_join = MatterJoin.find(params[:id])
        if params[:matter_join][:admin] == false
          return response_bad_request if minimum_required_administrator_check(@matter_join)
        end
        
        if @matter_join.update(admin: params[:matter_join][:admin])
          render json: { status: 200, message: "更新しました"}
        else
          render json: { status: 400, message: '参加出来ません。入力必須項目を確認してください', errors: @matter_join.errors }
        end
      end

      def destroy
        @matter = Matter.active.find(params[:matter_id])
        @matter_join = MatterJoin.find(params[:id])
        return response_forbidden unless correct_user

        if @matter.matter_joins.where(admin: true).count == 1 && @matter_join.admin?
          flash[:alert] = '管理者が最低1人以上必要なため削除できません。'
          redirect_back(fallback_location: members_matter_path(@matter))
        elsif (@matter_join.office.present? && @matter_join.office == @office) || (@matter_join.user.present? && @matter_join.user == current_user)
          @matter_join.destroy
          redirect_to clients_path, notice: '削除しました。'
        else
          @matter_join.destroy
          flash[:notice] = '削除しました。'
          redirect_back(fallback_location: members_matter_path(@matter))
        end
      end

      private

      def correct_user
        if @client.admin_check(current_user) || @matter.admin_check(current_user)
          return true if current_user.admin_check
        end
      end
    end
  end
end