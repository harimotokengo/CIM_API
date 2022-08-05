module Api
  module V1
    class ClientsController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      def index
        clients = search_client
        client_data = Client.new()
        data = client_data.index_data(clients)
        render json: { status: 200, data: data.uniq }
      end

      
      def show
        @client = Client.find(params[:id])
        return response_forbidden unless correct_user
        data = { 
          client: @client, 
          contact_phone_numbers: @client.contact_phone_numbers,
          contact_emails: @client.contact_emails,
          contact_addresses: @client.contact_addresses
          }
        render json: { status: 200, data: @client}
      end

      def client_matters
        @client = Client.active.find(params[:id])
        # pageとかsortとかは必要であれば追加
        matters = @client.matters
        data = []
        matters.each do |matter|
          matter.matter_assigns
          data << {matter: matter, matter_assigns: matter.matter_assigns}
        end
        render json: { status: 200, data: data}
      end

      def get_category_parents
        matter_category_parents = MatterCategory.where(ancestry: nil)
        render json: { status: 200, data: matter_category_parents}
      end

      def get_category_children
        matter_category_children = MatterCategory.find(params[:category_parent_id]).children
        render json: { status: 200, data: matter_category_children}
      end

      def create
        @client = Client.new(client_params)
        template_group_id = params[:client][:matters_attributes][:"0"][:task_template_group_id]
        if @client.client_joins[0].belong_side_id == '組織'
          @client.client_joins[0].office_id = current_user.belonging_office.id
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
          TaskTemplateGroup.find(template_group_id).save_matter_tasks(@client.matters[0], current_user)
          # @client.matters[0].save_matter_tasks
          # @client.create_client_log(current_user)
          
          render json: { status: 200, message: "登録しました"}
        else
          render status: 400, json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @client.errors }
        end
      end

      def update
        @client = Client.find(params[:id])
        return response_forbidden unless correct_user
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
        @clients = Client.active.joins(matters: :matter_joins)
                          .joins(:client_joins)
                          .where(['matters.archive = ?', true])
                          .where(['client_joins.user_id = ? or matter_joins.office_id = ? or client_joins.office_id = ? or matter_joins.user_id = ?', current_user.belonging_office, current_user, current_user.belonging_office, current_user])
                          .where(['name = ? AND first_name = ?', @name, @first_name]).distinct
        @opponents = Opponent.joins(matter: :matter_joins)
                              .joins(matter: {client: :client_joins})
                              .where(['clients.archive = ?', true])
                              .where(['matters.archive = ?', true])
                              .where(['client_joins.user_id = ? or matter_joins.office_id = ? or client_joins.office_id = ? or matter_joins.user_id = ?', current_user.belonging_office, current_user, current_user.belonging_office, current_user])
                              .where(['opponents.name = ? OR opponents.name = ? OR opponents.name = ? OR opponents.name = ? AND opponents.first_name = ?', @full_name, @harf_space_fullname, @hull_space_fullname, @name, @first_name]).distinct
        if @clients.blank? && @opponents.blank?
          render json: { status: 200, message: 'OK' }
        else
          data = []
          @clients.each do |client|
            data << client.full_name
          end
          @opponents.each do |opponent|
            data << opponent.full_name
          end 
          render json: { status: 200, message: "#{data.count}件見つかりました", data: data }
          
        end
      end

      # clientの個人情報を空白にして更新する
      # archiveをfalseに更新
      # client_joinしてるofficeかuserのadmin権限
      def destroy
        @client = Client.find(params[:id])
        return response_forbidden unless correct_user
        @client.destroy_update
        render json: {status: 200, message: '削除しました'}
      end

      def get_join_users
        join_users = current_user.belonging_office.belonging_users
        render json: {status: 200, data: join_users}
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
          client_joins_attributes: %i[
            id belong_side_id admin office_id user_id _destroy
            ],
          matters_attributes: [
            :id, :user_id, :service_price,
            :folder_url, :description, :matter_status_id,
            :start_date, :finish_date, 
            :_destroy,
            matter_category_joins_attributes: [
              :id, :matter_id, :matter_category_id,
              :_destroy
            ],
            matter_joins_attributes: %i[
              id belong_side_id admin office_id
              user_id _destroy
            ],
            matter_assigns_attributes: %i[

            ],
            folder_urls_attributes: %i[
              id name url _destroy
            ],
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
            
          ]
        )
      end

      def correct_user
        if action_name == 'show'
          return true if @client.join_check(current_user)
        else
          return true if @client.admin_check(current_user) && current_user.admin_check
        end
      end

      def search_client
        if params[:q].present?
          @clients_key_words = params[:q][:matters_description_or_matters_matter_category_joins_matter_category_name_or_matters_tags_tag_name_or_client_full_name_or_client_full_name_kana_or_maiden_name_or_maiden_name_kana_or_profile_or_indentification_number_or_matters_opponents_opponent_full_name_or_matters_opponents_opponent_full_name_kana_or_matters_opponents_maiden_name_or_matters_opponents_maiden_name_kana_or_matters_opponents_profile_or_contact_phone_numbers_phone_number_or_contact_emails_email_or_matters_opponents_contact_phone_numbers_phone_number_or_matters_opponents_contact_emails_email_cont_any]
          # スペースが入力された場合分割
          key_words = @clients_key_words.split(/[[:blank:]]+/)
          # 分割したものをhash化
          grouping_hash = key_words.reduce({}) do |hash, word|
            hash.merge(word => { matters_description_or_matters_matter_category_joins_matter_category_name_or_matters_tags_tag_name_or_client_full_name_or_client_full_name_kana_or_maiden_name_or_maiden_name_kana_or_profile_or_indentification_number_or_matters_opponents_opponent_full_name_or_matters_opponents_opponent_full_name_kana_or_matters_opponents_maiden_name_or_matters_opponents_maiden_name_kana_or_matters_opponents_profile_or_contact_phone_numbers_phone_number_or_contact_emails_email_or_matters_opponents_contact_phone_numbers_phone_number_or_matters_opponents_contact_emails_email_cont_any: word })
          end
        end

        client_search = Client.joins(matters: :matter_joins)
                              .joins(:client_joins)
                              .where(['clients.archive = ?', true])
                              .where(['matters.archive = ?', true])
                              .where(['client_joins.user_id = ? or matter_joins.office_id = ? or client_joins.office_id = ? or matter_joins.user_id = ?', current_user.belonging_office, current_user, current_user.belonging_office, current_user])
                              .eager_load(matters: :tags) #dataに案件タグを入れる際にN+1が起きるのでキャッシュする
                              .eager_load(matters: :categories) #dataに案件カテゴリーを入れる際にN+1が起きるのでキャッシュする
                              
        clients = client_search.ransack({combinator: 'and', groupings: grouping_hash})
                              .result(distinct: true)
                              .paginate(page: params[:page], per_page: 25)
                              .order(created_at: :desc)
      end
    end
  end
end