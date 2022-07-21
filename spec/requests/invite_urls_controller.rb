require 'rails_helper'

RSpec.describe 'invite_urls_requests', type: :request do
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
  let!(:matter_join_office_other) { create(:user) }
  let!(:matter_admin_office_user) { create(:user) }
  let!(:matter_admin_office_admin) { create(:user) }
  let!(:injoin_user) { create(:user) }
  let!(:injoin_office_user) { create(:user) }

  let!(:client_join_office_user_belonging_info) { create(:belonging_info, user: client_join_office_user, office: client_join_office) }
  let!(:client_admin_office_user_belonging_info) { create(:belonging_info, user:client_admin_office_user, office:client_admin_office) }
  let!(:client_admin_office_admin_belonging_info) { create(:belonging_info, user: client_admin_office_admin, office: client_admin_office, admin: true) }
  let!(:matter_join_office_user_belonging_info) { create(:belonging_info, user: matter_join_office_user, office: matter_join_office) }
  let!(:matter_join_office_other_belonging_info) { create(:belonging_info, user: matter_join_office_other, office: matter_join_office) }
  let!(:matter_admin_office_user_belonging_info) { create(:belonging_info, user: matter_join_office_user, office:matter_join_office) }
  let!(:matter_admin_office_admin_belonging_info) { create(:belonging_info, user: matter_admin_office_admin, office: matter_admin_office, admin: true) }
  let!(:injoin_belonging_info) { create(:belonging_info, user: injoin_office_user, office: injoin_office, admin: true) }

  let!(:matter_category) { create(:matter_category) }
  let!(:pension_matter_category) { create(:matter_category, ancestry: '1', name: '年金') }

  let!(:client) { create(:client) }
  let!(:matter) { create(:matter, client: client) }
  let!(:matter_category_join) { create(:matter_category_join, matter: matter) }
  let!(:opponent) { create(:opponent, matter: matter) }
  let!(:office_matter_join) { create(:matter_join, matter: matter, office: matter_join_office, belong_side_id: '組織', admin: false) }
  let!(:admin_office_matter_join) { create(:matter_join, matter: matter, office: matter_admin_office, belong_side_id: '組織') }
  let!(:user_matter_join) { create(:matter_join, matter: matter, user: matter_join_user, belong_side_id: '個人', admin: false, office_id: nil) }
  let!(:admin_user_matter_join) { create(:matter_join, matter: matter, user: matter_admin_user, belong_side_id: '個人', office_id: nil) }
  let!(:office_client_join) { create(:client_join, client: client, office: client_join_office, belong_side_id: '組織', admin: false) }
  let!(:admin_office_client_join) { create(:client_join, client: client, office: client_admin_office, belong_side_id: '組織') }
  let!(:user_client_join) { create(:client_join, client: client, user: client_join_user, belong_side_id: '個人', admin: false, office_id: nil) }
  let!(:admin_user_client_join) { create(:client_join, client: client, user: client_admin_user, belong_side_id: '個人', office_id: nil) }

  # 招待された案件/クライアント参加画面を表示
  describe 'GET #show' do
    context '正常系' do
      context '案件参加' do
        context '不参加ユーザーでログイン' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(response).to have_http_status 200
          end
          it '参加画面に表示するデータが取得できること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(JSON.parse(response.body)['data']['inviter']).to eq invite_url.user.full_name
            # expect(JSON.parse(response.body)['data']['limit_date']).to eq invite_url.limit_date.to_json
            expect(JSON.parse(response.body)['data']['invited_destination_name']).to eq invite_url.set_invited_destination_name
          end
        end
        context '案件参加ユーザーでログイン' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(response).to have_http_status 200
          end
          it '参加画面に表示するデータが取得できること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(JSON.parse(response.body)['data']['inviter']).to eq invite_url.user.full_name
            # expect(JSON.parse(response.body)['data']['limit_date']).to eq invite_url.limit_date.to_json
            expect(JSON.parse(response.body)['data']['invited_destination_name']).to eq invite_url.set_invited_destination_name
          end
        end
        context 'クライアント参加ユーザーでログイン' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(response).to have_http_status 200
          end
          it '参加画面に表示するデータが取得できること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(JSON.parse(response.body)['data']['inviter']).to eq invite_url.user.full_name
            # expect(JSON.parse(response.body)['data']['limit_date']).to eq invite_url.limit_date.to_json
            expect(JSON.parse(response.body)['data']['invited_destination_name']).to eq invite_url.set_invited_destination_name
          end
        end
      end
      context 'クライアント参加' do
        context '不参加ユーザーでログイン' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: nil, user: matter_admin_office_admin, join: false, client: client)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(response).to have_http_status 200
          end
          it '参加画面に表示するデータが取得できること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: nil, user: matter_admin_office_admin, join: false, client: client)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(JSON.parse(response.body)['data']['inviter']).to eq invite_url.user.full_name
            # expect(JSON.parse(response.body)['data']['limit_date']).to eq invite_url.limit_date.to_json
            expect(JSON.parse(response.body)['data']['invited_destination_name']).to eq invite_url.set_invited_destination_name
          end
        end
        context 'クライアント参加ユーザーでログイン' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: nil, user: matter_admin_office_admin, join: false, client: client)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(response).to have_http_status 200
          end
          it '参加画面に表示するデータが取得できること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: nil, user: matter_admin_office_admin, join: false, client: client)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(JSON.parse(response.body)['data']['inviter']).to eq invite_url.user.full_name
            # expect(JSON.parse(response.body)['data']['limit_date']).to eq invite_url.limit_date.to_json
            expect(JSON.parse(response.body)['data']['invited_destination_name']).to eq invite_url.set_invited_destination_name
          end
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
          get api_v1_invite_url_path(invite_url, tk: invite_url.token)
          expect(response).to have_http_status 401
        end
        it '参加画面に表示するデータが取得できないこと' do
          invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
          get api_v1_invite_url_path(invite_url, tk: invite_url.token)
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
      context '不参加ユーザーでログイン' do
        context '招待URLが不正' do
          it '400エラーが返ってくること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: nil)
            expect(response).to have_http_status 400
          end
          it '参加画面に表示するデータが取得できないこと' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: nil)
            expect(JSON.parse(response.body)['data']).to eq nil
          end
        end
        context 'tokenが期限切れ' do
          it '400エラーが返ってくること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil, limit_date: 10.minutes.ago)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(response).to have_http_status 400
          end
          it '参加画面に表示するデータが取得できないこと' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil, limit_date: 10.minutes.ago)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(JSON.parse(response.body)['data']).to eq nil
          end
        end
        context 'tokenがアクセス済み' do
          it '400エラーが返ってくること' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            invite_url.join = true
            invite_url.save
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(response).to have_http_status 400
          end
          it '参加画面に表示するデータが取得できないこと' do
            invite_url = create(:invite_url, token: '0123456789abcdef', matter: matter, user: matter_admin_office_admin, join: false, client: nil)
            invite_url.join = true
            invite_url.save
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            get api_v1_invite_url_path(invite_url, tk: invite_url.token)
            expect(JSON.parse(response.body)['data']).to eq nil
          end
        end
      end
    end
  end
end