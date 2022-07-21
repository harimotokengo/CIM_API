module Api
  module V1
    class InviteUrlsController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      # 参加画面
      def show
        @invite_url = InviteUrl.find(params[:id])
        params_token = params[:tk]
        return response_bad_request unless @invite_url.invite_url_check(params_token)
        data = @invite_url.get_invite_data
        render json: {status: 200, data: data}
      end
    end
  end
end