module Api
  module V1
    class OfficesController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?
      before_action :response_forbidden, only: [:update], unless: :correct_user
      
      def create
        @office = Office.new(office_params)
        if @office.save
          render json: { status: 200, message: "登録しました"}
        else
          render status: 400, json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @office.errors }
        end
      end

      def show
        @office = current_user.belonging_office
        # renderするデータはデザインを確認してから
      end

      def update
        @office = current_user.belonging_office

        if @office.update(office_params)
          render json: { status: 200, message: "更新しました"}
        else
          render status: 400, json: { status: 400, message: '更新出来ません。入力必須項目を確認してください', errors: @office.errors }
        end
      end
    

    

      private

      def office_params
        params.require(:office).permit(
          :name,       :phone_number,
          :post_code,  :prefecture,
          :prefecture, :address, :archive
        )
      end

      def correct_user
        unless current_user.current_belonging.admin?
          return false
        end
      end
    end
  end
end