module Api
  module V1
    class OfficeUsersController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?
      before_action :response_forbidden, unless: :correct_user

      # 所属ユーザー一覧
      def index
        @office = current_user.belonging_office
        @users = @office.belonging_users
        render json: { status: 200, data: @users}
      end

      def create
        access_token = request.headers[:HTTP_ACCESS_TOKEN]
        @invite_user_form = InviteUserForm.new(user_params)
        if @invite_user_form.save
          logout
          login(params[:invite_user_form][:email], params[:invite_user_form][:password])
          render json: { status: 200, message: "登録しました", id: current_user.id, email: current_user.email}
        else
          render status: 400, json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @user.errors }
        end
      end

      # default_priceとadminの更新
      def update
        belonging_info = current_user.current_belonging
        if belonging_info.update(belonging_info_params)
          render json: { status: 200, message: "更新しました"}
        else
          render status: 400, json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: belonging.errors }
        end
      end

      # 所属から退所へ更新
      def detroy
        user = User.find(params[:id])
        user.current_belonging.status_id = '退所'
        user.save
        render json: { status: 200, message: "退所しました"}
      end
    end

    private

    def user_params
      params.require(:invite_user_form).permit(
        :email, :password,
        :password_confirmation,
        :last_name,       :first_name,
        :last_name_kana,  :first_name_kana,
        :user_id, :office_id, :status_id, :user_job_id
      )
    end

    def belonging_info_params
      params.require(:belonging_info).permit(
        :default_price, :admin
      )
    end
  end
end