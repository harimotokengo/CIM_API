module Api
  module V1
    class ClientsController < ApplicationController
      before_action :response_unauthorized, unless: :logged_in?
      # before_action :set_client, only: %i[show update]

      def index
        # デザインで確認
      end

      def show
        @client = Client.find(params[:id])
      end

      def get_matter_category
        matter_category_parents = MatterCategory.where(ancestry: nil)
        matter_category_children = MatterCategory.find(params[:category_parent_id]).children
        render json: {matter_categories: category_parents
          matter_category_children: matter_category_children}
      end

      # client登録
      #   client_joinとか
      #   matter
      #     matter_joinとか
      #   今回使用するテンプレートを選択
      # client.matters.lastのtask_template_groupから
      # task_templateを取得
      # task_templateからtaskを作成（名前と作業段階だけが入ったやつ）

      def create
        @client = Client.new(client_params)
        # paramsに
        @client.client_type_id = params[:tab_btn]
        # @client.matters[0].set_joinメソッドを作ってまとめる
        if @client.matters[0].matter_joins[0].belong_side_id == 1
          @client.matters[0].matter_joins[0].office_id = @office.id
        else
          @client.matters[0].matter_joins[0].user_id = current_user.id
        end
        @client.matters[0].start_date = Time.now if @client.matters[0].matter_status_id == 1 && @client.matters[0].start_date.blank?
        tag_list = params[:client][:matters_attributes][:"0"][:tag_name].split(',') unless params[:client][:matters_attributes][:"0"][:tag_name].nil?
        if @client.save
          @client.matters[0].save_matter_tags(tag_list) unless params[:client][:matters_attributes][:"0"][:tag_name].nil?
          @client.matters[0].save_matter_tasks
          # @client.create_client_log(current_user)
          
          flash[:notice] = '登録しました。'
          # redirect_to matter_path(@client.matters[0])
        else
          flash.now[:alert] = '登録出来ません。入力必須項目を確認してください。'
          render :new
        end
      end

      def update
        @client = Client.find(params[:id])
        @client.client_type_id = params[:tab_btn]
        if @client.update(client_params)
          # @client.update_client_log(current_user) if @client.saved_changes?
          render json: { status: 200, message: "更新しました"}
        else
          render status: 400, json: { status: 400, message: '更新出来ません。入力必須項目を確認してください', errors: belonging.errors }
        end
      end

      # clientの個人情報を空白にして更新する
      # archiveをfalseに更新
      # client_joinしてるofficeかuserのadmin権限
      def destroy

      end

      private

      def client_params
        params.require(:client).permit(
          :name, :name_kana, :first_name,
          :first_name_kana, :profile,
          :maiden_name, :maiden_name_kana,
          :indentification_number, :birth_date,
          :client_type_id, :archive,
          cient_joins_attributes: [
            :id, :belong_side_id, :admin, :office_id,
            :user_id, :_destroy
          ],
          contact_addresses_attributes: [
            :id, :category, :memo, :post_code, :prefecture,
            :address, :send_by_personal, :_destroy
          ],
          contact_emails_attributes: [
            :id, :category, :email, :memo, :_destroy
          ],
          contact_phone_numbers_attributes: [
            :id, :category, :memo, :phone_number, :extension_number, :_destroy
          ],
          matters_attributes: [
            :id, :user_id, :service_price,
            :folder_url, :description, :matter_status_id,
            :start_date, :finish_date, 
            # :matter_category_id,:task_group_template_id, 
            :_destroy,
            { matter_joins_attributes: %i[
              id belong_side_id admin office_id user_id _destroy
              ],
              # folder_urls_attributes: %i[
              #   id name url _destroy
              # ],
              fees_attributes: %i[
                id fee_type_id price price_type
                monthly_date_id pay_times _destroy
              ],
              opponents_attributes: [
                :id, :name, :name_kana,
                :first_name, :first_name_kana,
                :maiden_name, :maiden_name_kana,
                :phone_number, :profile,
                :birth_date, :opponent_type,
                :opponent_relation_type,
                :_destroy,
                { contact_addresses_attributes: [
                  :id, :category, :memo, :post_code, :prefecture,
                  :address, :send_by_personal, :_destroy
                ],
                  contact_emails_attributes: [
                    :id, :category, :email, :memo, :_destroy
                  ],
                  contact_phone_numbers_attributes: [
                    :id, :category, :memo, :phone_number, :extension_number, :_destroy
                  ] }
              ]
            }
          ]
        )
      end

      # updateとshowで
      def correct_user

      end
    end
  end
end


# matter.tasksからtemplate_groupおよびテンプレート作成
# matter = Matter.find(params[:id])
# tasks = matter.tasks
# task_template_group = TaskTemplateGroup.create(name: params[:task_template_group][:name])
# tasks.each do |task|
#   TaskTemplate.create(name: task.name, template_group_id: task_template_group.id)
# end