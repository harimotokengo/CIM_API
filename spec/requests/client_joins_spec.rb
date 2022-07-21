require 'rails_helper'

RSpec.describe 'client_joins_requests', type: :request do
  let!(:client_join_office) { create(:office) }
  let!(:client_admin_office) { create(:office) }
  let!(:injoin_office) { create(:office) }

  let!(:client_join_user) { create(:user) }
  let!(:client_admin_user) { create(:user) }
  let!(:client_join_office_user) { create(:user) }
  let!(:client_admin_office_user) { create(:user) }
  let!(:client_admin_office_admin) { create(:user) }
  let!(:injoin_user) { create(:user) }
  let!(:injoin_office_user) { create(:user) }

  let!(:client_join_office_user_belonging_info) { create(:belonging_info, user: client_join_office_user, office: client_join_office) }
  let!(:client_admin_office_user_belonging_info) { create(:belonging_info, user:client_admin_office_user, office:client_admin_office) }
  let!(:client_admin_office_admin_belonging_info) { create(:belonging_info, user: client_admin_office_admin, office: client_admin_office, admin: true) }
  let!(:injoin_belonging_info) { create(:belonging_info, user: injoin_office_user, office: injoin_office, admin: true) }

  let!(:matter_category) { create(:matter_category) }
  let!(:pension_matter_category) { create(:matter_category, ancestry: '1', name: '年金') }

  let!(:client) { create(:client) }
  let!(:matter) { create(:matter, client: client) }
  let!(:matter_category_join) { create(:matter_category_join, matter: matter) }
  let!(:opponent) { create(:opponent, matter: matter) }
  
  let!(:office_client_join) { create(:client_join, client: client, office: client_join_office, belong_side_id: '組織', admin: false) }
  let!(:admin_office_client_join) { create(:client_join, client: client, office: client_admin_office, belong_side_id: '組織') }
  let!(:user_client_join) { create(:client_join, client: client, user: client_join_user, belong_side_id: '個人', admin: false, office_id: nil) }
  let!(:admin_user_client_join) { create(:client_join, client: client, user: client_admin_user, belong_side_id: '個人', office_id: nil) }

  # describe 'GET #index' do
  #   context '正常系' do
  #     context 'クラアント参加事務所ユーザーでログイン' do
  #       it 'リクエストが成功すること' do
  #         login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
  #         get api_v1_client_client_joins_path(client)
  #         expect(response).to have_http_status 200
  #       end
  #     end
  #     context 'クライアントユーザーでログイン' do
  #       it 'リクエストが成功すること' do
  #         login_user(client_join_user, 'Test-1234', api_v1_login_path)
  #         get api_v1_client_client_joins_path(client)
  #         expect(response).to have_http_status 200
  #       end
  #     end
  #   end
  #   context '準正常系' do
  #     context '未ログイン' do
  #       it '401エラーが返ってくること' do
  #         get api_v1_client_client_joins_path(client)
  #         expect(response).to have_http_status 401
  #         expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
  #       end
  #     end
  #     context '不参加ユーザーでログイン' do
  #       it '403エラーが返ってくること' do
  #         login_user(injoin_user, 'Test-1234', api_v1_login_path)
  #         get api_v1_client_client_joins_path(client)
  #         expect(response).to have_http_status 403
  #         expect(JSON.parse(response.body)['message']).to eq "Forbidden"
  #       end
  #     end
  #     context '不参加事務所ユーザーでログイン' do
  #       it '403エラーが返ってくること' do
  #         login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
  #         get api_v1_client_client_joins_path(client)
  #         expect(response).to have_http_status 403
  #         expect(JSON.parse(response.body)['message']).to eq "Forbidden"
  #       end
  #     end
  #   end
  # end

    describe 'POST #create_token' do
    context '正常系' do
      context 'クライアント管理事務所管理者でログイン' do
        it 'リクエストが成功すること' do
          login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to change(InviteUrl, :count).by(1)
        end  
      end
      context 'クライアント管理個人ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to change(InviteUrl, :count).by(1)
        end 
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
        it '登録されないこと' do
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to_not change(InviteUrl, :count)
        end 
      end
      context '不参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されないこと' do
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to_not change(InviteUrl, :count)
        end 
      end
      context '不参加事務所管理者でログイン' do
        it '403エラーが返ってくること' do
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されないこと' do
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to_not change(InviteUrl, :count)
        end 
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されないこと' do
          login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to_not change(InviteUrl, :count)
        end 
      end
      context 'クライアント参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(client_join_user, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されないこと' do
          login_user(client_join_user, 'Test-1234', api_v1_login_path)
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to_not change(InviteUrl, :count)
        end 
      end
    end
  end
end