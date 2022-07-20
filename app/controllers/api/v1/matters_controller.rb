module Api
  module V1
    class MattersController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      def index
        user_client_matters = current_user.join_clients.joins(:matters).where(client_joins: {user_id: current_user}).to_a
        office_client_matters = current_user.join_clients.joins(:matters).where(client_joins: {office_id: current_user.belonging_office}).to_a.compact
        user_matters = current_user.join_matters.to_a
        office_matters = (current_user.belonging_office.join_matters if current_user.belonging_office).to_a.compact
        matters = (user_client_matters+office_client_matters).uniq
        
        render json: {status: 200, data: matters}
      end

      def create
        @client = Client.find(params[:client_id])
        return response_forbidden unless correct_user
        @matter = current_user.matters.new(matter_params)
        case @matter.matter_joins[0].belong_side_id
        when '組織'
          @matter.matter_joins[0].office_id = current_user.belonging_office.id
        when '個人'
          @matter.matter_joins[0].user_id = current_user.id
        end
        @matter.matter_joins[0].admin = true
        @matter.client_id = @client.id
        @matter.start_date = Time.now if @matter.matter_status_id == 1 && @matter.start_date.blank?
        tag_list = params[:matter][:tag_name].split(',') unless params[:matter][:tag_name].nil?
        if @matter.save
          @matter.save_matter_tags(tag_list) unless params[:matter][:tag_name].nil?
          # @matter.create_matter_log(current_user)
          render json: { status: 200, message: "登録しました"}
        else
          render status: 400, json: { status: 400, message: '登録出来ません。入力必須項目を確認してください', errors: @matter.errors }
        end
      end

      def show
        @matter = Matter.active.find(params[:id])
        @client = @matter.client
        return response_forbidden unless correct_user
        render json: { status: 200, data: @matter}
      end

      def update
        @matter = Matter.active.find(params[:id])
        @client = @matter.client
        return response_forbidden unless correct_user
        tag_list = params[:matter][:tag_name].split(',') unless params[:matter][:tag_name].nil?
        if @matter.update(matter_params)
          @matter.save_matter_tags(tag_list) unless params[:matter][:tag_name].nil?
          @matter.update(start_date: Time.now) if @matter.matter_status_id == 1 && @matter.start_date.blank?
          @matter.update(finish_date: Time.now) if @matter.matter_status_id == 5 && @matter.finish_date.blank?
          # @matter.update_matter_log(current_user)
          render json: { status: 200, message: "更新しました"}
        else
          render status: 400, json: { status: 400, message: '更新出来ません。入力必須項目を確認してください', errors: @matter.errors }
        end
      end

      def tag_auto_complete
        matter_tags = Tag.joins(matter_tags: [matter: :matter_joins]).where(['matters.archive = ?', true]).where(['matter_joins.office_id = ? OR matter_joins.user_id = ?', @office.id, current_user.id])
        inquiry_tags = Tag.joins(inquiry_tags: [inquiry: [project: :project_assigns]]).where(['projects.archive = ?', true]).where(['project_assigns.office_id = ? OR project_assigns.user_id = ?', @office.id, current_user.id])
        tags = Tag.where(id: (matter_tags + inquiry_tags))
        tags_sql = Tag.sanitize_sql("tag_name like '%#{params[:term]}%'")
        tags = tags.select(:tag_name).where(tags_sql)
        tags = tags.map(&:tag_name)
        render json: {status: 200, data: tags}
      end

      # 関係者の個人情報を空白にしてmatter.archiveをfalseにする
      # レコードは全部残す
      def destroy
        @matter = Matter.active.find(params[:id])
        @client = @matter.client
        return response_forbidden unless correct_user
        @matter.destroy_update
        render json: {status: 200, message: '削除しました'}
      end

      def get_join_users
        if params[:client_id].blank? && params[:id]
          @matter = Matter.active.find(params[:id])
          @client = @matter.client.active
        else
          @client = Client.active.find(params[:client_id])
          @matter = nil
        end
        join_users = []
        join_users << User.joins(:matter_joins).joins(:client_joins)
                          .where('matter_joins.matter_id = ? or client_joins.client_id = ?', @matter, @client).distinct

        join_users << User.joins(belonging_office: :matter_joins).joins(belonging_office: :client_joins)
                            .where('matter_joins.matter_id = ? or client_joins.client_id = ?', @matter, @client).distinct
        render json: {status: 200, data: join_users.uniq}
      end

      private

      def matter_params
        params.require(:matter).permit(
          :matter_genre_id, :service_price,
          :description, :matter_status_id,
          :start_date, :finish_date,
          # :task_group_template_id, 
          :archive,
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
          ],
          matter_joins_attributes: %i[
            id belong_side_id admin office_id user_id _destroy
          ],
          folder_urls_attributes: %i[
            id name url _destroy
          ],
          matter_category_joins_attributes: %i[
            id matter_id matter_category_id
            _destroy
          ],
          matter_assigns_attributes: %i[
            id user_id _destroy
          ]
        )
      end

      def correct_user
        if action_name == 'create'
          return true if @client.join_check(current_user)
        elsif action_name == 'show'
          return true if @matter.join_check(current_user) || @client.join_check(current_user)
        else
          if @client.admin_check(current_user) || @matter.admin_check(current_user)
            return true if current_user.admin_check
          end
        end
      end
    end
  end
end