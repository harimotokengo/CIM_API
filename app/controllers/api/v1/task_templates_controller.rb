module Api
  module V1
    class TaskTemplatesController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      def create
        @task_template_group = current_user.task_template_groups.new(task_template_params)
        if @task_template_group.save
          render json: { status: 200, message: "登録しました"}
        else
          render json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @task_template_group.errors }
        end
      end

      def update
        @task_template_group = TaskTemplateGroup.active.find(params[:id])
        return response_forbidden unless correct_user
        if @task_template_group.update(task_template_params)
          render json: { status: 200, message: "更新しました"}
        else
          render json: { status: 400, message: '更新出来ません。入力必須項目を確認してください', errors: @task_template_group.errors }
        end
      end

      def destroy
        @task_template_group = TaskTemplateGroup.active.find(params[:id])
        return response_forbidden unless correct_user
        @task_template_group.update(archive: false)
        render json: { status: 200, message: "削除しました"}
      end

      private

      def task_template_params
        params.require(:task_template_group).permit(
          :use_id, :matter_category_id,
          :name, :description, :archive, :public_flg,
          task_templates_attributes: %i[
            id name work_stage_id _destroy
          ]
        )
      end

      def correct_user
        return true if @task_template_group.user.identify_check(current_user) || @task_template_group.user.admin_check
      end
    end
  end
end