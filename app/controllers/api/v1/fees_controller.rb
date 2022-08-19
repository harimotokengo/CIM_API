module Api
  module V1
    class FeesController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?
      # before_action :set_fee, only: %i[edit update destroy]
      # before_action :set_create, only: %i[create]

      def index
        @matters = Matter.active_matters.joins(:matter_joins).where(['matter_joins.office_id = ? OR matter_joins.user_id = ?', @office.id, current_user.id])
        @advisor_matters = @matters.joins(:fees).where('fees.fee_type_id = ?', 3)
        @spot_matters = @matters.joins(:fees).where.not('fees.fee_type_id = ?', 3)
        @year_statistics = params[:year_statistics] if params[:year_statistics].present?
        @sales_management = params[:sales_management] if params[:sales_management].present?
        @month = params[:month] if params[:month].present?
        @year = params[:year] if params[:year].present?
        @now_month = if @month.present?
                      "#{@month}-01".to_date
                    else
                      Time.now.beginning_of_month.to_date
                    end
        @now_year = if @year.present?
                      "#{@year}-01-01".to_date
                    else
                      Time.now.beginning_of_month.to_date
                    end
        if @sales_management.present?
          sales_management
        elsif @year_statistics.present?
          year_calculation
        else
          month_calculation
        end
      end

      def create
        @fee = Fee.new(fee_params)
        @matter = @fee.matter
        return response_forbidden unless correct_user
        @fee.price = 0 if @fee.fee_type_id == 6
        if @fee.save
          # @fee.create_fee_log(current_user)
          render json: {status: 200, message: '登録しました'}
        else
          render json: {status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @fee.erros}
        end
      end

      def update
        @fee = Fee.find(params[:id])
        @matter = @fee.matter
        return response_forbidden unless correct_user
        params[:fee][:price] = 0 if params[:fee][:fee_type_id] == '6'
        if @fee.update(fee_params)
          # @fee.update_fee_log(current_user)
          render json: {status: 200, message: '更新しました'}
        else
          render json: {status: 400, message: '更新出来ません。入力必須項目を確認してください', errors: @fee.erros}
        end
      end

      def destroy
        @fee = Fee.find(params[:id])
        @matter = @fee.matter
        return response_forbidden unless correct_user
        @fee.update(archive: false)
        # @fee.delete_fee_log(current_user)
        render json: {status: 200, message: '削除しました'}
      end

      private

      def fee_params
        params.require(:fee).permit(
          :fee_type_id, :price, :deadline,
          :pay_times, :monthly_date_id,
          :current_payment, :price_type, :paid_date,
          :paid_amount, :pay_off, :description,
          :matter_id, :archive
        )
      end

      def correct_user
        if action_name == 'create'
          return true if @matter.join_check(current_user) || @matter.client.join_check(current_user)
        elsif action_name == 'update'
          return true if @matter.join_check(current_user) || @matter.client.join_check(current_user)
        else
          if @matter.admin_check(current_user) || @matter.client.admin_check(current_user)
            return true if current_user.admin_check
          end
        end
      end

      def month_calculation
        # 顧問
        @month_advisor_matters = @advisor_matters.where('start_date <= ? OR start_date IS NULL', @now_month.prev_month.end_of_month)
                                                .where('finish_date >= ? OR finish_date IS NULL', @now_month.prev_month)
        @month_advisor_fees = @month_advisor_matters.sum(:price)
        @month_advisor_matters = @month_advisor_matters.distinct
        # スポット（今月全額入金済（分割以外））
        @full_amount_matters = @spot_matters.where('fees.pay_off = ? or fees.price <= fees.paid_amount', true)
        @paid_spot_matters = @full_amount_matters.where('fees.paid_date BETWEEN ? AND ?', @now_month, @now_month.end_of_month)
        @paid_spot_fees_sum_paid_amount = @paid_spot_matters.sum(:paid_amount)
        @paid_spot_matters = @paid_spot_matters.distinct
      end

      def year_calculation; end

      def sales_management
        @no_apply_fee_matters = @spot_matters.joins(:matter_joins, :fees)
                                            .where(['matter_joins.office_id = ? OR matter_joins.user_id = ?', @office.id, current_user.id])
                                            .where(['fees.pay_off = ?', false])
                                            .distinct
        @fee_deadline_matters = @no_apply_fee_matters.where.not(['fees.fee_type_id = ? or fees.fee_type_id = ?', 3, 6])
                                                    .where(['fees.deadline < ?', @now_month.end_of_month])
                                                    #  SQLインジェクション要チェック
                                                    .where('fees.paid_amount is null or fees.price > fees.paid_amount')
        @fee_no_deadline_matters = @no_apply_fee_matters.where.not(['fees.fee_type_id = ? or fees.fee_type_id = ?', 3, 6])
                                                        #  SQLインジェクション要チェック
                                                        .where(['fees.deadline is null'])
                                                        #  SQLインジェクション要チェック
                                                        .where('fees.paid_amount is null or fees.price > fees.paid_amount')
      end
    end
  end
end
