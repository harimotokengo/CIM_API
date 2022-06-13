module Api
  module V1
    class SessionsController < Api::V1::Base
      def create
        access_token = request.headers[:HTTP_ACCESS_TOKEN]
        logout
        @user = login(params[:email], params[:password])
        if @user
          render json: { status: 200, message: "ログインしました", id: current_user.id, email: current_user.email} 
        else
          response_not_found
        end
      end

      def destroy
        access_token = request.headers[:HTTP_ACCESS_TOKEN]
        logout
        response_success('SessionsController', 'destroy')
      end

      def me
        if current_user
          @user = current_user
        else
          response_not_found
        end
      end
    end
  end
end