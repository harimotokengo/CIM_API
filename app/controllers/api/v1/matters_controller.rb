module Api
  module V1
    class MattersController < Api::V1::Base
      before_action :response_unauthorized, unless: :logged_in?

      # show以外のread関係はまだ作らない
      def show
        # 表示内容はデザインで確認
        # @work_logs = @matter.work_logs.order(created_at: 'desc').paginate(page: params[:page], per_page: 10)
        # @work_log_admin = @matter.matter_joins.find_by(['office_id = ? OR user_id = ?', @office.id, current_user.id])
        # @work_log = @matter.work_logs.build
        render json: { status: 200, matter: @matter}
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

      def update
        @client = Client.find(params[:client_id])
        @matter = Matter.active_matters.find(params[:id])
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
        render json: tags.to_json
      end

      private

      def matter_params
        params.require(:matter).permit(
          :matter_genre_id, :service_price,
          :description, :matter_status_id,
          :start_date, :finish_date,
          :matter_category_id,
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
          ]
        )
      end

      # createはclientに参加している
      # updateはmatterかclientの管理権限
      # show関係はclientかmatterに参加している
      # destroyはclientかmatterのadminおよび管理ユーザーか
      def correct_user
        if action_name == 'create' || action_name == 'show'
          return true if @client.join_check(current_user)
        else
          return true if @client.admin_check(current_user) && current_user.admin_check
        end
      end
    end
  end
end