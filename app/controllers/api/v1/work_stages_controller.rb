module Api
  module V1
    class WorkStagesController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      def create
        @work_stage = current_user.work_stages.new(work_stage_params)
        if @work_stage.save
          render json: { status: 200, message: "登録しました"}
        else
          render json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @work_stage.errors }
        end
      end

      def update
        @work_stage = WorkStage.active.find(params[:id])
        return response_forbidden unless correct_user
        if @work_stage.update(work_stage_params)
          render json: { status: 200, message: "更新しました"}
        else
          render json: { status: 400, message: '更新出来ません。入力必須項目を確認してください', errors: @@work_stage.errors }
        end
      end

      def destroy
        @work_stage = WorkStage.active.find(params[:id])
        return response_forbidden unless correct_user
        @work_stage.update(archive: false)
        render json: { status: 200, message: "削除しました"}
      end
    end

    private

    def work_stage_params
      params.require(:work_stage).permit(
        :name, :matter_category_id, :archive, :public_flg
      )
    end

    def correct_user
      return true if @work_stage.user.identify_check(current_user) || @work_stage.user.admin_check
    end
  end
end