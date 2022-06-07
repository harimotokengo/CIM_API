module Api
  module V1
    class UsersController < Api::V1::Base
      # skip_before_action :require_login, only: [:create]
      p 2222222222
      def create
        binding.pry
        access_token = request.headers[:HTTP_ACCESS_TOKEN]
        @user = User.new(user_params)
        
        if @user.save
          auto_login(@user)
          render json: {id: @user.id, email: @user.email}
          response_success('UsersController', 'create')
        else
          render json: {errors: @user.errors}
          response_bad_request
        end
      end
    
      # def show
      #   # 先週分
      #   @prev_week_first_date = Time.current.prev_week.beginning_of_week
      #   @prev_week_last_date = Time.current.prev_week.end_of_week
      #   @prev_week_work_logs = @user.work_logs.where('worked_date BETWEEN ? AND ?', @prev_week_first_date, @prev_week_last_date)
      #   @prev_week_tasks = @tasks.where('start_date <= ? AND finish_date >= ?', @prev_week_last_date, @prev_week_first_date)
      #   # 今週分
      #   @week_first_date = Time.current.beginning_of_week
      #   @week_last_date = Time.current.end_of_week
      #   @week_work_logs = @user.work_logs.where('worked_date BETWEEN ? AND ?', @week_first_date, @week_last_date)
      #   @week_tasks = @tasks.where('start_date <= ? AND finish_date >= ?', @week_last_date, @week_first_date)
      #   # charge_matter(「相談のみ」、「終了」以外)
      #   @matters = @user.charged_matters.active_matters
      #                   .joins(:matter_joins)
      #                   .where.not('matter_status_id = ? OR matter_status_id = ?', 4, 5)
      #                   .where(['matter_joins.office_id = ? OR matter_joins.user_id = ?', @office.id, current_user.id])
      #                   .distinct
      #                   .order('created_at desc').paginate(page: params[:page], per_page: 10)
      #   # 通知TOP10
      #   @notifications = @user.passive_notifications.first(10)
      # end

      def update
        if @user.update(user_params)
          flash[:notice] = '更新しました'
          redirect_to user_path(@user)
        else
          flash.now[:alert] = '更新出来ません。入力必須項目を確認してください'
          render :edit
        end
      end

      def destroy
        # 事務所を退所
        @belonging_info.status_id = '退所'
        if @belonging_info.save
          # 事務所が有料プランに入っている場合、有料アカウントの使用数を更新する
          @office.subscription_quantity_update
          flash[:notice] = '退所処理しました'
        else
          flash[:alert] = '退所処理に失敗しました'
        end
        redirect_to users_path
      end

      private

      def user_params
        params.require(:user).permit(
          :email,           :archive,
          :last_name,       :first_name,
          :last_name_kana,  :first_name_kana,
          :membership_number, :user_job_id,
          :password,
          :password_confirmation
          # :avatar,
        )
      end
    end
  end
end

