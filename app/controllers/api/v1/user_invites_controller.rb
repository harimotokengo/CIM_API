module Api
  module V1
    class UserInvitesController < Api::V1::Base
      before_action :response_unauthorized, only: [:new, :create], unless: :logged_in?
      before_action :correct_user, only: [new, :create]
      # GET事務所招待画面
      def new
        # officeのセット
        # adminでない場合はfalse
        # office_userでない場合はfalse
        return unless params[:user_invite].present?
    
        @user_invite = UserInvite.find(params[:user_invite])
        @token_url = if Rails.env.development?
                       "http://localhost:3000/user_invites/#{@user_invite.id}?tk=" + @user_invite.token
                     else
                       "https://www.mrcim.com/user_invites/#{@user_invite.id}?tk=" + @user_invite.token
                     end
        render json: { status: 200, token_url: @token_url, user_invite: @user_invite }
      end

      # POST 事務所招待URLを作成
      def create
        # officeのセット
        # adminでない場合はfalse
        # office_userでない場合はfalse
        @user_invite = current_user.sent_user_invites.new(
          token: SecureRandom.urlsafe_base64(16),
          limit_date: Time.now.tomorrow,
          join: false
        )
        if @user_invite.save
          render json: ( status: 200, user_invite: @user_invite )
        else
          response_internal_server_error
        end
      end

      # GET 事務所参加確認画面
      def show
        @user_invite = UserInvite.find(params[:id])
        @invite_office = @user_invite.sender.belonging_office
        @params_token = params[:tk]
        if @user_invite.limit_date >= Time.now && @user_invite.token == @params_token && @user_invite.join?
          render json: ( status: 200, user_invite: @user_invite, invite_office: invite_office, params_token: @params_token )
        else
          render status: 400, json: { status: 400, message: '無効なURLです。' }
        end
      end

      # POST アカウントを作成せず事務所参加
      def join
        access_token = request.headers[:HTTP_ACCESS_TOKEN]
        @user = User.find_by(params[:email])
        if @user.belongign_office
          return false
        end
        logout
        login(params[:email], params[:password])
        # すでにその事務所に所属している場合はfalse
        
        # 現在所属している事務所がある場合は退所
        # belonging_infoをcreate
        # ログイン
        # あとはsessions#createと同じ
        
      end

      # POST アカウントを作成して事務所参加
      def reg_and_join
        # officeをセット
        @invite_user_form = InviteUserForm.new(user_params)
        if @invite_user_form.save
          logout
          login(user_params[:email], user_params[:password])
          render json: { status: 200, message: "登録しました", id: current_user.id, email: current_user.email} 
        else
          render status: 400, json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @user.errors }
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

    end
  end
end