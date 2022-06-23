module Api
  module V1
    class UserInvitesController < Api::V1::Base
      before_action :response_unauthorized, only: [:new, :create], unless: :logged_in?
      before_action :response_forbidden, only: [:new, :create], unless: :correct_user
      # GET事務所招待画面
      def new
        office = current_user.belonging_office
        return unless params[:user_invite].present?
    
        @user_invite = UserInvite.find(params[:user_invite])
        @token_url = if Rails.env.development? || Rails.env.test?
                       "http://localhost:3000/api/v1/user_invites/#{@user_invite.id}?tk=" + @user_invite.token
                     else
                       "https://www.mrcim.com/api/v1/user_invites/#{@user_invite.id}?tk=" + @user_invite.token
                     end
        render status: 200,json: { status: 200, token_url: @token_url, user_invite: @user_invite }
      end

      # POST 事務所招待URLを作成
      def create
        @user_invite = current_user.sent_user_invites.new(
          token: SecureRandom.urlsafe_base64(16),
          limit_date: Time.now.tomorrow,
          join: false
        )
        if @user_invite.save
          render json: { status: 200, user_invite: @user_invite }
        else
          response_internal_server_error
        end
      end

      # GET 事務所参加確認画面
      def show
        @user_invite = UserInvite.find(params[:id])
        @invite_office = @user_invite.sender.belonging_office
        @params_token = params[:tk]
        if @user_invite.limit_date >= Time.now && @user_invite.token == @params_token && !@user_invite.join?
          render json: { 
            status: 200, user_invite: @user_invite, 
            invite_office: @invite_office, 
            params_token: @params_token 
          }
        else
          render status: 400, json: { status: 400, message: '無効なURLです。' }
        end
      end

      # POST アカウントを作成せず事務所参加
      # 後でbelonging_infoモデルに処理をまとめる&transaction
      def join
        access_token = request.headers[:HTTP_ACCESS_TOKEN]
        logout
        user = login(params[:email], params[:password])
        if user
          user_invite = UserInvite.find(params[:user_invite_id])
          invite_office = user_invite.sender.belonging_office
          belonging_info = BelongingInfo.new(
            office_id: invite_office.id,
            user_id: user.id,
            status_id: '所属'
          )
          if user.belonging_office && user.belonging_office == invite_office
            response_conflict('BelongingInfo')
            return
          elsif user.current_belonging&.admin? && user.belonging_office != invite_office
            render status: 403,json: { status: 403, message: "管理ユーザーは移籍出来ません"}
            return
          end
          user.current_belonging.update(status_id: '退所') if user.current_belonging
          
          if user.current_belonging.status_id == '退所' && user_invite.limit_date >= Time.now && !user_invite.join?
            if belonging_info.save
              user_invite.update(join: true)
              render json: { status: 200, message: "参加しました", id: current_user.id, email: current_user.email}
            else
              response_internal_server_error
            end
          end
        else
          response_not_found
        end
      end

      # # POST アカウントを作成して事務所参加
      def reg_and_join
        access_token = request.headers[:HTTP_ACCESS_TOKEN]
        # officeをセット
        @invite_user_form = InviteUserForm.new(user_params)
        if @invite_user_form.save
          logout
          login(user_params[:email], user_params[:password])
          render json: { status: 200, message: "登録しました", id: current_user.id, email: current_user.email} 
        else
          render status: 400, json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @invite_user_form.errors }
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

      def correct_user
        if current_user.current_belonging&.admin?
          return true
        end
      end
    end
  end
end