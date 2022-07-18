module Api
  module V1
    class InviteUrlsController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      # 参加画面
      def show
        @invite_url = InviteUrl.find(params[:id])
        params_token = params[:tk]
        return response_bad_request unless @invite_url.invite_check(params_token)
        inviter = @invite_url.sender.full_name
        limit_date = @invite_url.limit_date
        invited_destination_name = @invite_url.get_invited_destination_name
        data = [inviter: inviter, 
          limit_date: limit_date, 
          invited_destination_name: invited_destination_name]
        render json: {status: 200, data: data}
      end
    end
  end
end