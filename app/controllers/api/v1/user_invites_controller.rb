module Api
  module V1
    class UserInvitesController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      def new
        @belonging_info = BelongingInfo.new
        return unless params[:user_invite].present?
    
        @user_invite = UserInvite.find(params[:user_invite])
        @token_url = if Rails.env.development?
                       "http://localhost:3000/user_invites/#{@user_invite.id}?tk=" + @user_invite.token
                     else
                       "https://www.mrcim.com/user_invites/#{@user_invite.id}?tk=" + @user_invite.token
                     end
      end

      def make_invite_url
        @user_invite = current_user.sent_user_invites.new(
          token: SecureRandom.urlsafe_base64(16),
          limit_date: Time.now.tomorrow,
          join: false
        )
        @user_invite.save
        # redirect_to new_user_invite_path(user_invite: @user_invite)

        # @user_inviteのtokenをrender
      end
      # 
    end
  end
end

# アカウントがある人のjoin
# アカウントがない人のjoin
# sessionは一旦削除して再ログインしてjoin