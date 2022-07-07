require 'rails_helper'

RSpec.describe 'matters_requests', type: :request do
  let!(:office) { create(:office) }
  let!(:admin_office) { create(:office) }
  let!(:injoin_office) { create(:office) }
  

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin_user) { create(:user) }
  let!(:independent_user) { create(:user) }
  let!(:independent_admin) { create(:user) }
  let!(:admin_office_user) { create(:user) }
  let!(:admin_office_admin) { create(:user) }

  let!(:injoin_independent_user) { create(:user) }
  let!(:injoin_user) { create(:user) }
  let!(:injoin_admin) { create(:user) }

  let!(:matter_category) { create(:matter_category) }

  let!(:client) { create(:client) }
  let!(:matter) { create(:matter, client: client, user: user, matter_category_id: matter_category.id) }
  # let!(:matter_join_office) { create(:matter_join, matter: matter, office: office, belong_side_id: 1, admin: false) }
  # let!(:matter_join_admin_office) { create(:matter_join, matter: matter, office: admin_office, belong_side_id: 1) }
  # let!(:matter_join_user) { create(:matter_join, matter: matter, user: independent_matter_user, belong_side_id: 2, admin: false) }
  # let!(:matter_join_admin) { create(:matter_join, matter: matter, user: independent_matter_admin, belong_side_id: 2) }
  let!(:client_join_office) { create(:client_join, client: client, office: office, belong_side_id: '組織', admin: false) }
  let!(:client_join_admin_office) { create(:client_join, client: client, office: admin_office, belong_side_id: '組織') }
  let!(:client_join_user) { create(:client_join, client: client, user: independent_user, belong_side_id: '個人', admin: false, office: nil) }
  let!(:client_join_admin_user) { create(:client_join, client: client, user: independent_admin, belong_side_id: '個人', office: nil) }
  
  let!(:belonging_info) { create(:belonging_info, user: user, office: office) }
  let!(:other_belonging_info) { create(:belonging_info, user: other_user, office: office) }
  let!(:office_admin_belonging_info) { create(:belonging_info, user: user, office: office, admin: true) }
  let!(:admin_office_belonging_info) { create(:belonging_info, user: admin_office_user, office: admin_office) }
  
  let!(:injoin_belonging_info) { create(:belonging_info, user: injoin_user, office: injoin_office) }

  # ログ未実装
  # タグ未確認
  describe 'POST #create' do
    before do
      contact_phone_number_params = {contact_phone_numbers_attributes: { "0": attributes_for(:contact_phone_number)}}
      invalid_contact_phone_number_params = { contact_phone_numbers_attributes: {"0": attributes_for(:contact_phone_number, phone_number: '123456') }}
      contact_email_params = { contact_emails_attributes: { "0": attributes_for(:contact_email) }  }
      contact_address_params = { contact_addresss_attributes: {  "0": attributes_for(:contact_address)}}
      @opponent_params = {opponents_attributes: { "0": attributes_for(:opponent)}}
      @contact_opponent_params = {opponents_attributes: { "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params) }}
      @matter_admin_office_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, office_id: office.id) }}
      @matter_admin_user_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, user_id: independent_admin, belong_side_id: '個人', office: nil) }}
      # @matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(opponent_params, matter_join_params) } }
      # @min_matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(matter_join_params) }}
      # @contact_matter_params = {matters_attributes: { "0": attributes_for(:matter, user_id: user.id).merge(contact_opponent_params, matter_join_params)}}
      
    end
    context '正常系' do
      # context 'クライアント管理事務所ユーザーでログイン' do
      #   context '案件、相手方等、相手方連絡先を入力' do
      #     it 'リクエストが成功すること' do
      #       login_user(admin_office_user, 'Test-1234', api_v1_login_path)
      #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
      #         ).merge( @matter_admin_office_params, @contact_opponent_params)
      #       post api_v1_client_matters_path(client), params: { matter: matter_params }
      #       expect(response).to have_http_status 200
      #     end
      #     it '登録されること' do
      #       login_user(admin_office_user, 'Test-1234', api_v1_login_path)
      #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
      #         ).merge( @matter_admin_office_params, @contact_opponent_params)
      #       expect do
      #         post api_v1_client_matters_path(client), params: { matter: matter_params }
      #       end.to change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(
      #         ContactEmail, :count).by(1) and change(ContactAddress, :count).by(1) and change(
      #           ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1)
      #     end
      #   end
      #   context '案件のみ入力' do
      #     it 'リクエストが成功すること' do
      #       login_user(admin_office_user, 'Test-1234', api_v1_login_path)
      #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
      #         ).merge( @matter_admin_office_params)
      #       post api_v1_client_matters_path(client), params: { matter: matter_params }
      #       expect(response).to have_http_status 200
      #     end
      #     it '登録されること' do
      #       login_user(admin_office_user, 'Test-1234', api_v1_login_path)
      #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
      #         ).merge( @matter_admin_office_params)
      #       expect do
      #         post api_v1_client_matters_path(client), params: { matter: matter_params }
      #       end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
      #     end
      #   end
      #   context '案件と案件タグを入力' do
      #     it '登録されること' do
      #       login_user(admin_office_user, 'Test-1234', api_v1_login_path)
      #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id, tag_name: '案件タグ'
      #         ).merge(@matter_admin_office_params)
      #       expect do
      #         post api_v1_client_matters_path(client), params: { matter: matter_params }
      #       end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1) and change(MatterTag, :count).by(1)
      #     end
      #   end
      # end
      context 'クライアント管理個人ユーザーでログイン' do
        context '案件、相手方等、相手方連絡先を入力' do
          it 'リクエストが成功すること' do
            login_user(independent_admin, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params, @contact_opponent_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(independent_admin, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params, @contact_opponent_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(
              ContactEmail, :count).by(1) and change(ContactAddress, :count).by(1) and change(
                ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1)
          end
        end
        context '案件のみ入力' do
          it 'リクエストが成功すること' do
            login_user(independent_admin, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(independent_admin, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          end
        end
        context '案件と案件タグを入力' do
          it '登録されること' do
            login_user(independent_admin, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id, tag_name: '案件タグ'
              ).merge(@matter_admin_user_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1) and change(MatterTag, :count).by(1)
          end
        end
      end
    end
    # context '準正常系' do
    #   context '未ログイン状態の場合' do
    #     it '401エラーが返ってくること' do
    #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
    #         ).merge(@matter_admin_user_params, @contact_opponent_params)
    #       post api_v1_client_matters_path(client), params: { matter: matter_params }
    #       expect(response).to have_http_status 401
    #       expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
    #     end
    #     it '登録されない' do
    #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
    #         ).merge(@matter_admin_user_params, @contact_opponent_params)
    #       expect do
    #         post api_v1_client_matters_path(client), xhr: true, params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
    #     end
    #   end
    #   context 'パラメータが無効な場合' do
    #     it 'リクエストが成功すること' do
    #       login_user(admin_office_user, 'Test-1234', api_v1_login_path)
    #       matter_params = attributes_for(:matter, matter_category_id: ''
    #         ).merge(@matter_admin_office_params, @contact_opponent_params)
    #       post api_v1_client_matters_path(client), params: { matter: matter_params }
    #       expect(response).to have_http_status 400
    #       expect(JSON.parse(response.body)['message']).to eq "登録出来ません。入力必須項目を確認してください"
    #     end
    #     it '登録されない' do
    #       login_user(admin_office_user, 'Test-1234', api_v1_login_path)
    #       matter_params = attributes_for(:matter, matter_category_id: ''
    #         ).merge(@matter_admin_office_params, @contact_opponent_params)
    #       expect do
    #         post api_v1_client_matters_path(client), params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
    #     end
    #   end
    #   context 'client参加がない個人ユーザーでログイン' do
    #     it '403エラーが返ってくること' do
    #       login_user(injoin_independent_user, 'Test-1234', api_v1_login_path)
    #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
    #         ).merge(@matter_admin_user_params, @contact_opponent_params)
    #         post api_v1_client_matters_path(client), params: { matter: matter_params }
    #       expect(response.status).to eq 403
    #       expect(JSON.parse(response.body)['message']).to eq "Forbidden"
    #     end
    #     it '登録されない' do
    #       login_user(injoin_independent_user, 'Test-1234', api_v1_login_path)
    #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
    #         ).merge(@matter_admin_user_params, @contact_opponent_params)
    #       expect do
    #         post api_v1_client_matters_path(client), params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
    #     end
    #   end
    #   context 'client参加がない事務所userでログイン' do
    #     it '403エラーを返すこと' do
    #       login_user(injoin_user, 'Test-1234', api_v1_login_path)
    #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
    #         ).merge(@matter_admin_user_params, @contact_opponent_params)
    #       post api_v1_client_matters_path(client), params: { matter: matter_params }
    #       expect(response.status).to eq 403
    #       expect(JSON.parse(response.body)['message']).to eq "Forbidden"
    #     end
    #     it '登録されない' do
    #       login_user(injoin_user, 'Test-1234', api_v1_login_path)
    #       matter_params = attributes_for(:matter, matter_category_id: matter_category.id
    #         ).merge(@matter_admin_user_params, @contact_opponent_params)
    #       expect do
    #         post api_v1_client_matters_path(client), params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
    #     end
    #   end
    # end
  end
end


  
