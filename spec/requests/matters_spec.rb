require 'rails_helper'

RSpec.describe 'matters_requests', type: :request do
  let!(:client_join_office) { create(:office) }
  let!(:matter_join_office) { create(:office) }
  let!(:client_admin_office) { create(:office) }
  let!(:matter_admin_office) { create(:office) }
  let!(:injoin_office) { create(:office) }

  let!(:client_join_user) { create(:user) }
  let!(:client_admin_user) { create(:user) }
  let!(:client_join_office_user) { create(:user) }
  let!(:client_admin_office_user) { create(:user) }
  let!(:client_admin_office_admin) { create(:user) }
  let!(:matter_join_user) { create(:user) }
  let!(:matter_admin_user) { create(:user) }
  let!(:matter_join_office_user) { create(:user) }
  let!(:matter_admin_office_user) { create(:user) }
  let!(:matter_admin_office_admin) { create(:user) }
  let!(:injoin_user) { create(:user) }
  let!(:injoin_office_user) { create(:user) }

  let!(:matter_category) { create(:matter_category) }
  let!(:pension_matter_category) { create(:matter_category, ancestry: '1', name: '年金') }

  let!(:client) { create(:client) }
  let!(:matter) { create(:matter, client: client, matter_category_id: matter_category.id) }
  let!(:office_matter_join) { create(:matter_join, matter: matter, office: matter_join_office, belong_side_id: '組織', admin: false) }
  let!(:admin_office_matter_join) { create(:matter_join, matter: matter, office: matter_admin_office, belong_side_id: '組織') }
  let!(:user_matter_join) { create(:matter_join, matter: matter, user: matter_join_user, belong_side_id: '個人', admin: false) }
  let!(:admin_user_matter_join) { create(:matter_join, matter: matter, user: matter_admin_user, belong_side_id: '個人') }
  let!(:office_lient_join) { create(:client_join, client: client, office: client_join_office, belong_side_id: '組織', admin: false) }
  let!(:admin_officeclient_join) { create(:client_join, client: client, office: client_admin_office, belong_side_id: '組織') }
  let!(:user_client_join) { create(:client_join, client: client, user: client_join_user, belong_side_id: '個人', admin: false, office: nil) }
  let!(:admin_user_client_join) { create(:client_join, client: client, user: client_admin_user, belong_side_id: '個人', office: nil) }
  
  let!(:client_join_office_user_belonging_info) { create(:belonging_info, user: client_join_office_user, office: client_join_office) }
  let!(:client_admin_office_user_belonging_info) { create(:belonging_info, user:client_admin_office_user, office:client_admin_office) }
  let!(:client_admin_office_admin_belonging_info) { create(:belonging_info, user: client_admin_office_admin, office: client_admin_office, admin: true) }
  let!(:matter_join_office_user_belonging_info) { create(:belonging_info, user: matter_join_office_user, office: matter_join_office) }
  let!(:matter_admin_office_user_belonging_info) { create(:belonging_info, user: matter_join_office_user, office:matter_join_office) }
  let!(:matter_admin_office_admin_belonging_info) { create(:belonging_info, user: matter_admin_office_admin, office: matter_admin_office, admin: true) }

  let!(:injoin_belonging_info) { create(:belonging_info, user: injoin_user, office: injoin_office) }

  # ログ未実装
  describe 'POST #create' do
    before do
      contact_phone_number_params = {contact_phone_numbers_attributes: { "0": attributes_for(:contact_phone_number)}}
      invalid_contact_phone_number_params = { contact_phone_numbers_attributes: {"0": attributes_for(:contact_phone_number, phone_number: '123456') }}
      contact_email_params = { contact_emails_attributes: { "0": attributes_for(:contact_email) }  }
      contact_address_params = { contact_addresss_attributes: {  "0": attributes_for(:contact_address)}}
      @opponent_params = {opponents_attributes: { "0": attributes_for(:opponent)}}
      @contact_opponent_params = {opponents_attributes: { "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params) }}
      @matter_admin_office_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, office_id: matter_admin_office.id) }}
      @matter_admin_user_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, user_id: matter_admin_user, belong_side_id: '個人', office: nil) }}
      # @matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(opponent_params, matter_join_params) } }
      # @min_matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(matter_join_params) }}
      # @contact_matter_params = {matters_attributes: { "0": attributes_for(:matter, user_id: user.id).merge(contact_opponent_params, matter_join_params)}}
      
    end
    context '正常系' do
      context 'クライアント管理事務所ユーザーでログイン' do
        context '案件、相手方等、相手方連絡先を入力' do
          it 'リクエストが成功すること' do
            login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge( @matter_admin_office_params, @contact_opponent_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge( @matter_admin_office_params, @contact_opponent_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(
              ContactEmail, :count).by(1) and change(ContactAddress, :count).by(1) and change(
                ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1)
          end
        end
        context '案件のみ入力' do
          it 'リクエストが成功すること' do
            login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge( @matter_admin_office_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge( @matter_admin_office_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          end
        end
        context '案件と案件タグを入力' do
          it '登録されること' do
            login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id, tag_name: '案件タグ'
              ).merge(@matter_admin_office_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1) and change(MatterTag, :count).by(1)
          end
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        context '案件、相手方等、相手方連絡先を入力' do
          it 'リクエストが成功すること' do
            login_user(client_admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params, @contact_opponent_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(client_admin_user, 'Test-1234', api_v1_login_path)
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
            login_user(client_admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(client_admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          end
        end
        context '案件と案件タグを入力' do
          it '登録されること' do
            login_user(client_admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id, tag_name: '案件タグ'
              ).merge(@matter_admin_user_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1) and change(MatterTag, :count).by(1)
          end
        end
      end
    end
  #   context '準正常系' do
  #     context '未ログイン状態の場合' do
  #       it '401エラーが返ってくること' do
  #         matter_params = attributes_for(:matter, matter_category_id: pension_matter_category.id
  #           ).merge(@matter_admin_user_params, @contact_opponent_params)
  #         post api_v1_client_matters_path(client), params: { matter: matter_params }
  #         expect(response).to have_http_status 401
  #         expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
  #       end
  #       it '登録されない' do
  #         matter_params = attributes_for(:matter, matter_category_id: matter_category.id
  #           ).merge(@matter_admin_user_params, @contact_opponent_params)
  #         expect do
  #           post api_v1_client_matters_path(client), xhr: true, params: { matter: matter_params }
  #         end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
  #       end
  #     end
  #     context 'パラメータが無効な場合' do
  #       it 'リクエストが成功すること' do
  #         login_user(admin_office_user, 'Test-1234', api_v1_login_path)
  #         matter_params = attributes_for(:matter, matter_category_id: ''
  #           ).merge(@matter_admin_office_params, @contact_opponent_params)
  #         post api_v1_client_matters_path(client), params: { matter: matter_params }
  #         expect(response).to have_http_status 400
  #         expect(JSON.parse(response.body)['message']).to eq "登録出来ません。入力必須項目を確認してください"
  #       end
  #       it '登録されない' do
  #         login_user(admin_office_user, 'Test-1234', api_v1_login_path)
  #         matter_params = attributes_for(:matter, matter_category_id: ''
  #           ).merge(@matter_admin_office_params, @contact_opponent_params)
  #         expect do
  #           post api_v1_client_matters_path(client), params: { matter: matter_params }
  #         end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
  #       end
  #     end
  #     context 'client参加がない個人ユーザーでログイン' do
  #       it '403エラーが返ってくること' do
  #         login_user(injoin_independent_user, 'Test-1234', api_v1_login_path)
  #         matter_params = attributes_for(:matter, matter_category_id: matter_category.id
  #           ).merge(@matter_admin_user_params, @contact_opponent_params)
  #           post api_v1_client_matters_path(client), params: { matter: matter_params }
  #         expect(response.status).to eq 403
  #         expect(JSON.parse(response.body)['message']).to eq "Forbidden"
  #       end
  #       it '登録されない' do
  #         login_user(injoin_independent_user, 'Test-1234', api_v1_login_path)
  #         matter_params = attributes_for(:matter, matter_category_id: matter_category.id
  #           ).merge(@matter_admin_user_params, @contact_opponent_params)
  #         expect do
  #           post api_v1_client_matters_path(client), params: { matter: matter_params }
  #         end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
  #       end
  #     end
  #     context 'client参加がない事務所userでログイン' do
  #       it '403エラーを返すこと' do
  #         login_user(injoin_user, 'Test-1234', api_v1_login_path)
  #         matter_params = attributes_for(:matter, matter_category_id: matter_category.id
  #           ).merge(@matter_admin_user_params, @contact_opponent_params)
  #         post api_v1_client_matters_path(client), params: { matter: matter_params }
  #         expect(response.status).to eq 403
  #         expect(JSON.parse(response.body)['message']).to eq "Forbidden"
  #       end
  #       it '登録されない' do
  #         login_user(injoin_user, 'Test-1234', api_v1_login_path)
  #         matter_params = attributes_for(:matter, matter_category_id: matter_category.id
  #           ).merge(@matter_admin_user_params, @contact_opponent_params)
  #         expect do
  #           post api_v1_client_matters_path(client), params: { matter: matter_params }
  #         end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
  #       end
  #     end
  #   end
  end

  describe 'PUT #update' do
    context '正常系' do
      context 'クライアント管理事務所管理者でログイン' do
        it 'リクエストが成功すること' do
          login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
          matter_params = attributes_for(:matter, matter_category_id: pension_matter_category.id)
          put api_v1_client_matter_path(client, matter), params: { matter: matter_params }
          expect(response.status).to eq 200
        end
        it '更新されること' do
          login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
          matter_params = attributes_for(:matter, matter_category_id: pension_matter_category.id)
          expect do
            put api_v1_client_matter_path(client, matter), params: { matter: matter_params }
          end.to change { Matter.find(matter.id).matter_category_id }.from(matter.matter_category_id).to(pension_matter_category.id)
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          matter_params = attributes_for(:matter, matter_category_id: pension_matter_category.id)
          put api_v1_client_matter_path(client, matter), params: { matter: matter_params }
          expect(response.status).to eq 200
        end
        it '更新されること' do
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          matter_params = attributes_for(:matter, matter_category_id: pension_matter_category.id)
          expect do
            put api_v1_client_matter_path(client, matter), params: { matter: matter_params }
          end.to change { Matter.find(matter.id).matter_category_id }.from(matter.matter_category_id).to(pension_matter_category.id)
        end
      end
      context '案件管理事務所管理者でログイン' do
        it 'リクエストが成功すること' do
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          matter_params = attributes_for(:matter, matter_category_id: pension_matter_category.id)
          put api_v1_client_matter_path(client, matter), params: { matter: matter_params }
          expect(response.status).to eq 200
        end
        it '更新されること' do
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          matter_params = attributes_for(:matter, matter_category_id: pension_matter_category.id)
          expect do
            put api_v1_client_matter_path(client, matter), params: { matter: matter_params }
          end.to change { Matter.find(matter.id).matter_category_id }.from(matter.matter_category_id).to(pension_matter_category.id)
        end
      end
      context '案件管理個人ユーザーでログイン' do

      end
      # it 'matterへの参加(matter_join管理者、事務所参加)がある同事務所user(belonging_info管理者でない)の場合、リクエストが成功すること' do
      #   login_user(belonging_info2.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   put matter_path(matter), params: { matter: matter_params }
      #   expect(response.status).to eq 302
      #   expect(response).to redirect_to matter_path(matter)
      # end
      # it 'matterへの参加(matter_join管理者、事務所参加)がある同事務所user(belonging_info管理者でない)の場合、更新できること' do
      #   login_user(belonging_info2.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change { Matter.find(matter.id).matter_status_id }.from(1).to(2)
      # end
      # it 'matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者)の場合、リクエストが成功すること' do
      #   login_user(other_belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   put matter_path(matter), params: { matter: matter_params }
      #   expect(response.status).to eq 302
      #   expect(response).to redirect_to matter_path(matter)
      # end
      # it 'matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者)の場合、更新されること' do
      #   login_user(other_belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change { Matter.find(matter.id).matter_status_id }.from(1).to(2)
      # end
      # it 'matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者でない)の場合、リクエストが成功すること' do
      #   login_user(other_belonging_info4.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   put matter_path(matter), params: { matter: matter_params }
      #   expect(response.status).to eq 302
      #   expect(response).to redirect_to matter_path(matter)
      # end
      # it 'matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者でない)の場合、更新されること' do
      #   login_user(other_belonging_info4.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change { Matter.find(matter.id).matter_status_id }.from(1).to(2)
      # end
      # it 'matterへの参加(matter_join管理者でない、事務所参加)がある他事務所user(belonging_info管理者)の場合、リクエストが成功すること' do
      #   login_user(other2_belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   put matter_path(matter), params: { matter: matter_params }
      #   expect(response.status).to eq 302
      #   expect(response).to redirect_to matter_path(matter)
      # end
      # it 'matterへの参加(matter_join管理者でない、事務所参加)がある他事務所user(belonging_info管理者)の場合、更新されること' do
      #   login_user(other2_belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change { Matter.find(matter.id).matter_status_id }.from(1).to(2)
      # end
      # it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者)の場合、リクエストが成功すること' do
      #   login_user(other_belonging_info3.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   put matter_path(matter), params: { matter: matter_params }
      #   expect(response.status).to eq 302
      #   expect(response).to redirect_to matter_path(matter)
      # end
      # it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者)の場合、更新されること' do
      #   login_user(other_belonging_info3.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change { Matter.find(matter.id).matter_status_id }.from(1).to(2)
      # end
      # it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者でない)の場合、リクエストが成功すること' do
      #   login_user(other_belonging_info5.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   put matter_path(matter), params: { matter: matter_params }
      #   expect(response.status).to eq 302
      #   expect(response).to redirect_to matter_path(matter)
      # end
      # it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者でない)の場合、更新されること' do
      #   login_user(other_belonging_info5.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, matter_status_id: 2)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change { Matter.find(matter.id).matter_status_id }.from(1).to(2)
      # end
      # it 'アーカイブについて、matterへの参加(matter_join管理者、事務所参加)がある同事務所user(belonging_info管理者)の場合、リクエストが成功すること' do
      #   login_user(belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, archive: false)
      #   put matter_path(matter), params: { matter: matter_params }
      #   expect(response.status).to eq 302
      #   expect(response).to redirect_to clients_path
      # end
      # it 'アーカイブについて、matterへの参加(matter_join管理者、事務所参加)がある同事務所user(belonging_info管理者)の場合、更新されること' do
      #   login_user(belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, archive: false)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change { Matter.find(matter.id).archive }.from(true).to(false)
      # end
      # it 'アーカイブについて、matterへの参加(matter_join管理者、事務所参加)がある同事務所user(belonging_info管理者)の場合、編集ログが登録されること' do
      #   login_user(belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, archive: false)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change(EditLog, :count).by(1)
      # end
      # it 'アーカイブについて、matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者)の場合、リクエストが成功すること' do
      #   login_user(other_belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, archive: false)
      #   put matter_path(matter), params: { matter: matter_params }
      #   expect(response.status).to eq 302
      #   expect(response).to redirect_to clients_path
      # end
      # it 'アーカイブについて、matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者)の場合、更新されること' do
      #   login_user(other_belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, archive: false)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change { Matter.find(matter.id).archive }.from(true).to(false)
      # end
      # it 'アーカイブについて、matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者)の場合、編集ログが登録されること' do
      #   login_user(other_belonging_info.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, archive: false)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change(EditLog, :count).by(1)
      # end
      # it 'アーカイブについて、matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者でない)の場合、リクエストが成功すること' do
      #   login_user(other_belonging_info4.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, archive: false)
      #   put matter_path(matter), params: { matter: matter_params }
      #   expect(response.status).to eq 302
      #   expect(response).to redirect_to clients_path
      # end
      # it 'アーカイブについて、matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者でない)の場合、更新されること' do
      #   login_user(other_belonging_info4.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, archive: false)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change { Matter.find(matter.id).archive }.from(true).to(false)
      # end
      # it 'アーカイブについて、matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者でない)の場合、編集ログが登録されること' do
      #   login_user(other_belonging_info4.user, 'Test-1234', login_path)
      #   matter_params = attributes_for(:matter, archive: false)
      #   expect do
      #     put matter_path(matter), params: { matter: matter_params }
      #   end.to change(EditLog, :count).by(1)
      # end
      # リクエストが
      # タグを追加した場合、新たなタグが登録されること
      # リクエストが
      # タグが削除されること
    end
    # context '準正常系' do
    #   it '未ログイン状態の場合、ログイン画面にリダイレクトされること' do
    #     matter_params = attributes_for(:matter, matter_status_id: 2)
    #     put matter_path(matter), params: { matter: matter_params }
    #     expect(response.status).to eq 302
    #     expect(response).to redirect_to login_path
    #   end
    #   it '未ログイン状態の場合、更新されないこと' do
    #     matter_params = attributes_for(:matter, matter_status_id: 2)
    #     expect do
    #       put matter_path(matter), params: { matter: matter_params }
    #     end.to_not change { Matter.find(matter.id).matter_status_id } and change(EditLog, :count)
    #   end
    #   it 'パラメータが無効な場合、リクエストが成功すること' do
    #     login_user(belonging_info.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, matter_status_id: '')
    #     put matter_path(matter), xhr: true, params: { matter: matter_params }
    #     expect(response.status).to eq 200
    #   end
    #   it 'パラメータが無効な場合、更新されないこと' do
    #     login_user(belonging_info.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, matter_status_id: '')
    #     expect do
    #       put matter_path(matter), xhr: true, params: { matter: matter_params }
    #     end.to_not change { Matter.find(matter.id).matter_status_id } and change(EditLog, :count)
    #   end
    #   xit 'officeの登録がない場合、〇〇にリダイレクトされること' do
    #     # login_user(belonging_info.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, matter_status_id: 2)
    #     put matter_path(matter), params: { matter: matter_params }
    #     # expect(response).to redirect_to login_path
    #   end
    #   xit 'officeの登録がない場合、更新されない' do
    #     # login_user(belonging_info.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, matter_status_id: 2)
    #     expect do
    #       put matter_path(matter), params: { matter: matter_params }
    #     end.to_not change { Matter.find(matter.id).matter_status_id }
    #   end
    #   it 'matterへの参加がない場合、トップページにリダイレクトされること' do
    #     login_user(belonging_info.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, matter_status_id: 2)
    #     put matter_path(other_matter), params: { matter: matter_params }
    #     expect(response.status).to eq 302
    #     expect(response).to redirect_to root_path
    #   end
    #   it 'matterへの参加がない場合、更新されないこと' do
    #     login_user(belonging_info.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, matter_status_id: 2)
    #     expect do
    #       put matter_path(other_matter), params: { matter: matter_params }
    #     end.to_not change { Matter.find(matter.id).matter_status_id } and change(EditLog, :count)
    #   end
    #   it 'matterへの参加がない他事務所userの場合、トップページにリダイレクトされること' do
    #     login_user(other_belonging_info2.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, matter_status_id: 2)
    #     put matter_path(matter), params: { matter: matter_params }
    #     expect(response.status).to eq 302
    #     expect(response).to redirect_to root_path
    #   end
    #   it 'matterへの参加がない他事務所userの場合、更新されないこと' do
    #     login_user(other_belonging_info2.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, matter_status_id: 2)
    #     put matter_path(matter), params: { matter: matter_params }
    #     expect do
    #       put matter_path(matter), params: { matter: matter_params }
    #     end.to_not change { Matter.find(matter.id).matter_status_id } and change(EditLog, :count)
    #   end
    #   it 'アーカイブについて、matterへの参加(matter_join管理者、事務所参加)がある同事務所user(belonging_info管理者でない)の場合、リクエストが成功すること' do
    #     login_user(belonging_info2.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, archive: false)
    #     put matter_path(matter), params: { matter: matter_params }
    #     expect(response.status).to eq 302
    #     expect(response).to redirect_to root_path
    #   end
    #   it 'アーカイブについて、matterへの参加(matter_join管理者、事務所参加)がある同事務所user(belonging_info管理者でない)の場合、更新されないこと' do
    #     login_user(belonging_info2.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, archive: false)
    #     expect do
    #       put matter_path(matter), params: { matter: matter_params }
    #     end.to_not change { Matter.find(matter.id).archive }.from(true) and change(EditLog, :count)
    #   end
    #   it 'アーカイブについて、matterへの参加(matter_join管理者でない、事務所参加)がある他事務所user(belonging_info管理者)の場合、リクエストが成功すること' do
    #     login_user(other2_belonging_info.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, archive: false)
    #     put matter_path(matter), params: { matter: matter_params }
    #     expect(response.status).to eq 302
    #     expect(response).to redirect_to root_path
    #   end
    #   it 'アーカイブについて、matterへの参加(matter_join管理者でない、事務所参加)がある他事務所user(belonging_info管理者)の場合、更新されないこと' do
    #     login_user(other2_belonging_info.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, archive: false)
    #     expect do
    #       put matter_path(matter), params: { matter: matter_params }
    #     end.to_not change { Matter.find(matter.id).archive }.from(true) and change(EditLog, :count)
    #   end
    #   it 'アーカイブについて、matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者)の場合、リクエストが成功すること' do
    #     login_user(other_belonging_info3.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, archive: false)
    #     put matter_path(matter), params: { matter: matter_params }
    #     expect(response.status).to eq 302
    #     expect(response).to redirect_to root_path
    #   end
    #   it 'アーカイブについて、matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者)の場合、更新されないこと' do
    #     login_user(other_belonging_info3.user, 'Test-1234', login_path)
    #     matter_params = attributes_for(:matter, archive: false)
    #     expect do
    #       put matter_path(matter), params: { matter: matter_params }
    #     end.to_not change { Matter.find(matter.id).archive }.from(true) and change(EditLog, :count)
    #   end
    # end
  end
end


  
