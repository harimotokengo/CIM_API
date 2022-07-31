module Api
  module V1
    class TasksController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      def index
        # current_userのassign_task completeしてないやつ
        
      end

      def create
        @task = current_user.tasks.new(task_params)
        @matter = Matter.find(params[:task][:matter_id]) if params[:task][:matter_id].present?
        return response_forbidden unless correct_user
        @task.deadline_check
        # check_task_fee if @matter.present? || @task.matter.present?
        if @task.save
          # @task.create_task_log(current_user)
          # if params[:task][:task_assigns_attributes].present?
          #   @task.task_assigns.each do |task_assign|
          #     assign_user = User.find(task_assign.user_id)
          #     @task.create_notification_task_assign!(current_user, assign_user)
          #   end
          # end
          render json: {status: 200, message: '登録しました'}
        else
          render json: {status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @task.erros}
        end
      end

      def update
        @task = Task.find(params[:id])
        @matter = @task.matter if @task.matter
        return response_forbidden unless correct_user
        @task.deadline_check
        if @task.update!(task_params)
          # @task.update_task_log(current_user)
          # アサイン通知
          # タスク終了通知
          render json: {status: 200, message: '更新しました'}
        else
          render json: {status: 400, message: '更新出来ません。入力必須項目を確認してください', errors: @task.erros}
        end
      end

      def destroy
        @task = Task.find(params[:id])
        @matter = @task.matter if @task.matter
        return response_forbidden unless correct_user
        @task.update(archive: false)
        render json: {status: 200, message: '削除しました'}
      end

      private

      def task_params
        params.require(:task).permit(
          :name, :description, :priority,
          :task_status, 
          :matter_id,  :archive, :complete,
          :deadline, :work_stage_id,
          # task_fee_relations_attributes: [
          #   :id, :fee_id, :_destroy
          # ],
          # task_fees_attributes: [
          #   :id, :matter_id, :fee_type_id, :price, :price_type,
          #   :monthly_date_id, :pay_times, :_destroy
          # ],
          task_assigns_attributes: %i[
            id user_id _destroy
          ]
        )
      end

      def correct_user
        if action_name == 'create'
          if @matter
            return true if @matter.join_check(current_user) || @matter.client.join_check(current_user)
          else
            return true
          end
        elsif action_name == 'update'
          if @matter
            return true if @matter.join_check(current_user) || @matter.client.join_check(current_user)
          else
            return true if @task.user.identify_office_check(current_user) || @task.user.identify_check(current_user)
          end
        else
          if @matter
            if @task.matter.admin_check(current_user) || @task.matter.client.admin_check(current_user)
              return true if current_user.admin_check
            else
              return true if @task.user.identify_check(current_user) || @task.user.admin_check
            end
          else
            return true if @task.user.identify_check(current_user) || @task.user.admin_check
          end
        end
      end
    end
  end
end