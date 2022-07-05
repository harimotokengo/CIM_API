module Api
  module V1
    class ClientsController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?
      # before_action :set_client, only: %i[show update]

      def index
        user_matter_clients = current_user.join_matter_clients
        office_matter_clients = current_user.belonging_office.join_matter_clients
        user_clients = current_user.join_clients
        office_clients = current_user.belonging_office.join_clients
        cliants =  (user_clients + office_clients).distinct
        render json: { status: 200, clients: clients}
      end

      def show
        @client = Client.find(params[:id])
        if correct_user
          render json: { status: 200, client: @client}
        else
          response_forbidden
        end
      end

      def get_matter_category
        matter_category_parents = MatterCategory.where(ancestry: nil)
        matter_category_children = MatterCategory.find(params[:category_parent_id]).children
        render json: {matter_categories: category_parents,
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
        if @client.client_joins[0].belong_side_id == 1
          @client.client_joins[0].office_id = @office.id
        else
          @client.client_joins[0].user_id = current_user.id
        end
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
          # @client.matters[0].save_matter_tasks
          # @client.create_client_log(current_user)
          
          render json: { status: 200, message: "登録しました"}
        else
          render status: 400, json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @client.errors }
        end
      end

      def update
        @client = Client.find(params[:id])
        correct_user
        @client.client_type_id = params[:tab_btn]
        if @client.update(client_params)
          # @client.update_client_log(current_user) if @client.saved_changes?
          render json: { status: 200, message: "更新しました"}
        else
          render status: 400, json: { status: 400, message: '更新出来ません。入力必須項目を確認してください', errors: @client.errors }
        end
      end

      def conflict_check
        @name = params[:name]
        @first_name = params[:first_name]
        @full_name = @name + @first_name
        @harf_space_fullname = @name + ' ' + @first_name
        @hull_space_fullname = @name + '　' + @first_name
        @clients = Client.joins(matters: :matter_joins).where(['matters.archive = ?', true]).where(['matter_joins.office_id = ? OR matter_joins.user_id = ?', @office.id, current_user.id])
                         .where(['name = ? AND first_name = ?', @name, @first_name]).distinct
        @opponents = Opponent.joins(matter: :matter_joins).where(['matters.archive = ?', true]).where(['matter_joins.office_id = ? OR matter_joins.user_id = ?', @office.id, current_user.id])
                             .where(['name = ? OR name = ? OR name = ?', @full_name, @harf_space_fullname, @hull_space_fullname]).distinct
        if !@clients && !@opponents
          render json: { status: 200, message: 'OK' }
        elsif @clients
          render json: { status: 200, clients: @clients }
        elsif @opponents
          render json: { status: 200, opponents: @opponents }
        else
          render json: { status: 200, clients: @clients, opponents: @opponents }
        end
      end

      # clientの個人情報を空白にして更新する
      # archiveをfalseに更新
      # client_joinしてるofficeかuserのadmin権限
      # def destroy

      # end

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
          client_joins_attributes: %i[
            id belong_side_id admin office_id user_id _destroy
            ],
          matters_attributes: [
            :id, :user_id, :service_price,
            :folder_url, :description, :matter_status_id,
            :start_date, :finish_date, 
            :matter_category_id,
            # :task_group_template_id, 
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

      def correct_user
        if current_user.belonging_office
          client_join_check = @client.client_joins.exists?(['client_joins.office_id = ? OR client_joins.user_id = ?', current_user.belonging_office.id, current_user.id])
          matter_join_check = @client.matters.joins(:matter_joins).exists?(['matter_joins.office_id = ? OR matter_joins.user_id = ?', current_user.belonging_office.id, current_user.id])
        else
          client_join_check = @client.client_joins.exists?(['client_joins.user_id = ?',current_user.id])
          matter_join_check = @client.matters.joins(:matter_joins).exists?(['matter_joins.user_id = ?', current_user.id])
        end
        unless client_join_check && matter_join_check
          return false
        end
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