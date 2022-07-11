module Api
  module V1
    class Base < ApplicationController
      skip_forgery_protection
      # before_action :response_unauthorized, unless: :logged_in?
      # before_action :set_client_search,only: [:set_client_search], if: :logged_in?
      
      # 200 Success
      def response_success(class_name, action_name)
        render status: 200, json: { status: 200, message: "Success #{class_name.capitalize} #{action_name.capitalize}" }
      end

      # 400 Bad Request
      def response_bad_request
        render status: 400, json: { status: 400, message: 'Bad Request' }
      end

      # 401 Unauthorized
      def response_unauthorized
        render status: 401, json: { status: 401, message: 'Unauthorized' }
      end

      # 403 Forbidden
      def response_forbidden
        render status: 403, json: { status: 403, message: 'Forbidden' }
      end

      # 404 Not Found
      def response_not_found(class_name = 'page')
        render status: 404, json: { status: 404, message: "#{class_name.capitalize} Not Found" }
      end

      # 409 Conflict
      def response_conflict(class_name)
        render status: 409, json: { status: 409, message: "#{class_name.capitalize} Conflict" }
      end

      # 500 Internal Server Error
      def response_internal_server_error
        render status: 500, json: { status: 500, message: 'Internal Server Error' }
      end
      
      def set_client_search
        # 案件検索されたら
        if params[:q].present? &&
           (params[:q][:matters_description_or_matters_tags_tag_name_or_name_or_first_name_or_name_kana_or_first_name_kana_or_maiden_name_or_maiden_name_kana_or_profile_or_indentification_number_or_matters_opponents_name_or_matters_opponents_name_kana_or_matters_opponents_first_name_or_matters_opponents_first_name_kana_or_matters_opponents_maiden_name_or_matters_opponents_maiden_name_kana_or_matters_opponents_profile_or_contact_phone_numbers_phone_number_or_contact_emails_email_or_matters_opponents_contact_phone_numbers_phone_number_or_matters_opponents_contact_emails_email_cont_any].present? ||
           params[:q][:matters_matter_genre_id_eq].present?)
          @clients_key_words = params[:q][:matters_description_or_matters_tags_tag_name_or_name_or_first_name_or_name_kana_or_first_name_kana_or_maiden_name_or_maiden_name_kana_or_profile_or_indentification_number_or_matters_opponents_name_or_matters_opponents_name_kana_or_matters_opponents_first_name_or_matters_opponents_first_name_kana_or_matters_opponents_maiden_name_or_matters_opponents_maiden_name_kana_or_matters_opponents_profile_or_contact_phone_numbers_phone_number_or_contact_emails_email_or_matters_opponents_contact_phone_numbers_phone_number_or_matters_opponents_contact_emails_email_cont_any]
          # スペースが入力された場合分割
          key_words = @clients_key_words.split(/[[:blank:]]+/)
          # 分割したものをhash化
          grouping_hash = key_words.reduce({}) do |hash, word|
            hash.merge(word => { matters_description_or_matters_tags_tag_name_or_name_or_first_name_or_name_kana_or_first_name_kana_or_maiden_name_or_maiden_name_kana_or_profile_or_indentification_number_or_matters_opponents_name_or_matters_opponents_name_kana_or_matters_opponents_first_name_or_matters_opponents_first_name_kana_or_matters_opponents_maiden_name_or_matters_opponents_maiden_name_kana_or_matters_opponents_profile_or_contact_phone_numbers_phone_number_or_contact_emails_email_or_matters_opponents_contact_phone_numbers_phone_number_or_matters_opponents_contact_emails_email_cont_any: word })
          end
          # ジャンルが検索されている場合ハッシュに追加
            # カラム名を合わせる
          if params[:q][:matters_matter_genre_id_eq].present?
            grouping_hash[params[:q][:matters_matter_genre_id_eq]] = { matters_matter_genre_id_eq: params[:q][:matters_matter_genre_id_eq] }
          end
        end
        # client_joinしているclientも追加してdistinctする
        @client_search = Client.joins(matters: :matter_joins)
                               .where(['matters.archive = ?', true])
                               .where(['matter_joins.office_id = ? OR matter_joins.user_id = ?', @office.id, current_user.id])
                               .ransack({ combinator: 'and', groupings: grouping_hash })
        @search_clients = @client_search.result(distinct: true)
                                        .paginate(page: params[:page], per_page: 25)
                                        .order(created_at: :desc)
      end
    end
  end
end