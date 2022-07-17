module Api
  module V1
    class MatterAssignsController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      def create
        @matter = Matter.active.find(params[:matter_id])
        return response_forbidden unless correct_user
        return response_bad_request unless @matter.assignable_check(params[:matter_assign][:user_id])
        matter_assign = @matter.matter_assigns.new(user_id: params[:matter_assign][:user_id])
        
        if matter_assign.save
          # @matter.create_notification_matter_assign!(current_user, assign_user)
          render json: { status: 200, message: '登録しました。' }
        else
          render json: { status: 400, message: '登録できませんでした。'}
        end
      end

      def destroy
        @matter_assign = MatterAssign.find(params[:id])
        @matter = @matter_assign.matter
        return response_forbidden unless correct_user
        return response_bad_request unless @matter.assign_deletable_check(@matter_assign.user)
        @matter_assign.destroy
        render json: { status: 200, message: '担当を削除しました。' }
      end

      private

      def correct_user
        if @matter.client.join_check(current_user) || @matter.join_check(current_user)
          return true
        end
      end
    end
  end
end