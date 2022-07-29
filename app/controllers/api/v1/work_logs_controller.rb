module Api
  module V1
    class WorkLogController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      def create
        @work_log = current_user.work_logs.new(work_log_params)
        return response_forbidden unless correct_user
        if @work_log.save
      end

      def update
        @work_log = WorkLog.find(params[:id])

        if @work_log.update()
      end

      def destroy

      end

      private

      def work_log_params
        params.require(:work_log).permit(
          :working_time,  :content,
          :worked_date,   :detail_reflection
        )
      end

      def correct_user
        if action_name == 'create'
          if @matter
            return true if @matter.join_check(current_user) || @matter.client.join_check(current_user)
          else
            return true if @work_log.user.identify_office_check(current_user) || @work_log.user.identify_check(current_user)
          end
        elsif action_name == 'update'
          if @matter
            return true if @matter.join_check(current_user) || @matter.client.join_check(current_user)
          else
            return true if @work_log.user.identify_office_check(current_user) || @work_log.user.identify_check(current_user)
          end
        else
          if @matter
            if @matter.admin_check(current_user) || @matter.client.admin_check(current_user)
              return true if current_user.admin_check
            end
          else
            return true if @work_log.user.identify_check(current_user) || @work_log.user.admin_check
          end
        end
      end
    end
  end
end