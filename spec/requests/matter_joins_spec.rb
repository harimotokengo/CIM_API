require 'rails_helper'

RSpec.describe 'matter_joins_requests', type: :request do
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

  describe 'GET #index' do
    context '正常系' do
      context '案件参加事務所ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          get api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 200
        end
      end
      context '案件参加ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          get api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 200
        end
      end
      context 'クラアント参加事務所ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
          get api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 200
        end
      end
      context 'クライアントユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          get api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 200
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          get api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
      end
      context '不参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          get api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
      end
      context '不参加事務所ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          get api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
      end
    end
  end

  describe 'POST #create_token' do
    context '正常系' do
      context '案件管理事務所管理者でログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to change(InviteUrl, :count).by(1)
        end    
      end
      context '案件管理個人ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to change(InviteUrl, :count).by(1)
        end  
      end
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
      context '案件参加事務所ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されないこと' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          end.to_not change(InviteUrl, :count)
        end 
      end
      context '案件参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          post create_token_api_v1_matter_matter_joins_path(matter), params: { admin: false }
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されないこと' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
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

  describe 'GET #get_invite_url' do
    context '正常系' do
      context '案件管理事務所管理者でログイン' do
        it '招待URLを取得できること' do
          invite_url = create(:invite_url, matter: matter, user: matter_admin_office_admin)
          login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 200
          expect(JSON.parse(response.body)['data']).to eq "http://localhost:3000/invite_urls/#{invite_url.id}?tk=#{invite_url.token}"
        end
      end
      context '案件管理個人ユーザーでログイン' do
        it '招待URLを取得できること' do
          invite_url = create(:invite_url, matter: matter, user: matter_admin_user)
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 200
          expect(JSON.parse(response.body)['data']).to eq "http://localhost:3000/invite_urls/#{invite_url.id}?tk=#{invite_url.token}"
        end
      end
      context 'クライアント管理事務所管理者でログイン' do
        it '招待URLを取得できること' do
          invite_url = create(:invite_url, matter: matter, user: client_admin_office_admin)
          login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 200
          expect(JSON.parse(response.body)['data']).to eq "http://localhost:3000/invite_urls/#{invite_url.id}?tk=#{invite_url.token}"
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        it '招待URLを取得できること' do
          invite_url = create(:invite_url, matter: matter, user: client_admin_user)
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 200
          expect(JSON.parse(response.body)['data']).to eq "http://localhost:3000/invite_urls/#{invite_url.id}?tk=#{invite_url.token}"
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          invite_url = create(:invite_url, matter: matter, user: client_admin_user)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
        it '招待URLを取得できないこと' do
          invite_url = create(:invite_url, matter: matter, user: client_admin_user)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
      context '不参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          invite_url = create(:invite_url, matter: matter, user: injoin_user)
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '招待URLを取得できないこと' do
          invite_url = create(:invite_url, matter: matter, user: injoin_user)
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
      context '不参加事務所管理者でログイン' do
        it '403エラーが返ってくること' do
          invite_url = create(:invite_url, matter: matter, user: injoin_office_user)
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '招待URLを取得できないこと' do
          invite_url = create(:invite_url, matter: matter, user: injoin_office_user)
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        it '403エラーが返ってくること' do
          invite_url = create(:invite_url, matter: matter, user: matter_admin_office_user)
          login_user(matter_admin_office_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '招待URLを取得できないこと' do
          invite_url = create(:invite_url, matter: matter, user: matter_admin_office_user)
          login_user(matter_admin_office_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
      context '案件参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          invite_url = create(:invite_url, matter: matter, user: matter_join_office_user)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '招待URLを取得できないこと' do
          invite_url = create(:invite_url, matter: matter, user: matter_join_user)
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
      context 'クライアント管理事務所ユーザーでログイン' do
        it '403エラーが返ってくること' do
          invite_url = create(:invite_url, matter: matter, user: client_admin_office_user)
          login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '招待URLを取得できないこと' do
          invite_url = create(:invite_url, matter: matter, user: client_admin_office_user)
          login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          invite_url = create(:invite_url, matter: matter, user: client_join_user)
          login_user(client_join_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '招待URLを取得できないこと' do
          invite_url = create(:invite_url, matter: matter, user: client_join_user)
          login_user(client_join_user, 'Test-1234', api_v1_login_path)
          get get_invite_url_api_v1_matter_matter_joins_path(matter)
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
    end
  end

  describe 'POST #create' do
    context '正常系' do
      context '不参加ユーザーでログイン' do
        context '個人で参加' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            end.to change(MatterJoin, :count).by(1)
          end
        end
      end
      context '不参加事務所ユーザーでログイン' do
        context '組織で参加' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            end.to change(MatterJoin, :count).by(1)
          end
        end
        context '個人で参加' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            end.to change(MatterJoin, :count).by(1)
          end
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        context '個人で参加' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            end.to change(MatterJoin, :count).by(1)
          end
        end
      end
      context '案件参加ユーザーでログイン' do
        context '組織で参加' do
          it 'リクエストが成功すること' do
            belonging_info = create(:belonging_info, office: injoin_office, user: matter_join_user)
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            belonging_info = create(:belonging_info, office: injoin_office, user: matter_join_user)
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            end.to change(MatterJoin, :count).by(1)
          end
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '個人で参加' do
          it 'リクエストが成功すること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            end.to change(MatterJoin, :count).by(1)
          end
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '組織で参加' do
          it 'リクエストが成功すること' do
            belonging_info = create(:belonging_info, office: injoin_office, user:client_join_user)
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            belonging_info = create(:belonging_info, office: injoin_office, user: client_join_user)
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            end.to change(MatterJoin, :count).by(1)
          end
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          invite_url = create(:invite_url, matter: matter, user: client_admin_user)
          post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
          expect(response).to have_http_status 401
        end
        it '登録されないこと' do
          invite_url = create(:invite_url, matter: matter, user: client_admin_user)
          expect do
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
          end.to_not change(MatterJoin, :count)
        end
      end
      context '案件参加ユーザーでログイン' do
        context '個人で参加' do
          it '403エラーが返ってくること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            expect(response).to have_http_status 403
          end
          it '登録されないこと' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        context '組織で参加' do
          it '403エラーが返ってくること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            expect(response).to have_http_status 403
          end
          it '登録されないこと' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '個人で参加' do
          it '403エラーが返ってくること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            expect(response).to have_http_status 403
          end
          it '登録されないこと' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '組織で参加' do
          it '403エラーが返ってくること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            expect(response).to have_http_status 403
          end
          it '登録されないこと' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context '不参加ユーザーでログイン' do
        context 'パラメータが不正' do
          it '400エラーが返ってくること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: nil, invite_url_id: invite_url.id }
            expect(response).to have_http_status 400
          end
          it '登録されないこと' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: nil, invite_url_id: invite_url.id }
            end.to_not change(MatterJoin, :count)
          end
        end
        context 'tokenが期限切れ' do
          it '400エラーが返ってくること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user, limit_date: 1.minute.ago)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            expect(response).to have_http_status 400
          end
          it '登録されないこと' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user, limit_date: 1.minute.ago)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            end.to_not change(MatterJoin, :count)
          end
        end
        context 'tokenがアクセス済み' do
          it '400エラーが返ってくること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user, join: true)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            expect(response).to have_http_status 400
          end
          it '登録されないこと' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user, join: true)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '個人', invite_url_id: invite_url.id }
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context '事務所に所属していないユーザーでログイン' do
        context '組織で参加' do
          it '403エラーが返ってくること' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            expect(response).to have_http_status 403
          end
          it '登録されないこと' do
            invite_url = create(:invite_url, matter: matter, user: client_admin_user)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_matter_matter_joins_path(matter), params: { belong_side_id: '組織', invite_url_id: invite_url.id }
            end.to_not change(MatterJoin, :count)
          end
        end
      end
    end
  end

  describe 'PUT #update' do
    context '正常系' do
      context '案件管理事務所管理者でログイン' do
        context '案件個人参加を更新' do
          it 'リクエストが成功すること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to change { MatterJoin.find(user_matter_join.id).admin }.from(false).to(true)
          end
        end
        context '案件管理ユーザー参加を更新' do
          it 'リクエストが成功すること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: false)
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, admin_user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: false)
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, admin_user_matter_join.id), params: { matter_join: matter_join_params }
            end.to change { MatterJoin.find(admin_user_matter_join.id).admin }.from(true).to(false)
          end
        end
        context '案件事務所参加を更新' do
          it 'リクエストが成功すること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '組織', admin: true)
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter,office_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '組織', admin: true)
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, office_matter_join.id), params: { matter_join: matter_join_params }
            end.to change { MatterJoin.find(office_matter_join.id).admin }.from(false).to(true)
          end
        end
        context '案件管理事務所を更新' do
          it 'リクエストが成功すること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '組織', admin: false)
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter,admin_office_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '組織', admin: false)
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, admin_office_matter_join.id), params: { matter_join: matter_join_params }
            end.to change { MatterJoin.find(admin_office_matter_join.id).admin }.from(true).to(false)
          end
        end
      end
      context '案件管理ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it 'リクエストが成功すること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to change { MatterJoin.find(user_matter_join.id).admin }.from(false).to(true)
          end
        end
      end
      context 'クライアント管理事務所管理者でログイン' do
        context '案件ユーザー参加を更新' do
          it 'リクエストが成功すること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to change { MatterJoin.find(user_matter_join.id).admin }.from(false).to(true)
          end
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it 'リクエストが成功すること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_admin_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_admin_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to change { MatterJoin.find(user_matter_join.id).admin }.from(false).to(true)
          end
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        context '案件ユーザー参加を更新' do
          it '401エラーが返ってくること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 401
          end
          it '更新されないこと' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to_not change { MatterJoin.find(user_matter_join.id).admin }
          end
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it '403エラーが返ってくること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 403
          end
          it '更新されないこと' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to_not change { MatterJoin.find(user_matter_join.id).admin }
          end
        end
      end
      context '案件管理事務所ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it '403エラーが返ってくること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_admin_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 403
          end
          it '更新されないこと' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_admin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to_not change { MatterJoin.find(user_matter_join.id).admin }
          end
        end
      end
      context '案件参加ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it '403エラーが返ってくること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 403
          end
          it '更新されないこと' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to_not change { MatterJoin.find(user_matter_join.id).admin }
          end
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it '403エラーが返ってくること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 403
          end
          it '更新されないこと' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to_not change { MatterJoin.find(user_matter_join.id).admin }
          end
        end
      end
      context 'クライアント管理事務所ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it '403エラーが返ってくること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 403
          end
          it '更新されないこと' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to_not change { MatterJoin.find(user_matter_join.id).admin }
          end
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it '403エラーが返ってくること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 403
          end
          it '更新されないこと' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to_not change { MatterJoin.find(user_matter_join.id).admin }
          end
        end
      end
      context '案件不参加ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it '403エラーが返ってくること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 403
          end
          it '更新されないこと' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to_not change { MatterJoin.find(user_matter_join.id).admin }
          end
        end
      end
      context '案件不参加事務所ユーザーでログイン' do
        context '案件ユーザー参加を更新' do
          it '403エラーが返ってくること' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            expect(response).to have_http_status 403
          end
          it '更新されないこと' do
            matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_matter_matter_join_path(matter, user_matter_join.id), params: { matter_join: matter_join_params }
            end.to_not change { MatterJoin.find(user_matter_join.id).admin }
          end
        end
      end
      context '案件管理事務所管理者でログイン' do
        context '案件管理事務所管理者を更新' do
          context '管理者数が1の状態でadmin権限を解除' do
            before{
              MatterJoin.destroy_all
              ClientJoin.destroy_all
            }
            it '400エラーが返ってくること' do
              matter_join = create(:matter_join, matter: matter, office: matter_admin_office, user: nil, belong_side_id: '組織', admin: true)
              matter_join_params = attributes_for(:matter_join, belong_side_id: '組織', admin: false)
              login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
              put api_v1_matter_matter_join_path(matter, matter_join.id), params: { matter_join: matter_join_params }
              expect(response).to have_http_status 400
            end
            it '更新されないこと' do
              matter_join = create(:matter_join, matter: matter, office: matter_admin_office, user: nil, belong_side_id: '組織', admin: true)
              matter_join_params = attributes_for(:matter_join, belong_side_id: '組織', admin: false)
              login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
              expect do
                put api_v1_matter_matter_join_path(matter, matter_join.id), params: { matter_join: matter_join_params }
              end.to_not change { MatterJoin.find(matter_join.id).admin }
            end
          end
          context '個人参加に変更' do
            it '更新されないこと' do
              matter_join_params = attributes_for(:matter_join, belong_side_id: '個人', admin: true)
              login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
              expect do
                put api_v1_matter_matter_join_path(matter, admin_office_matter_join.id), params: { matter_join: matter_join_params }
              end.to_not change { MatterJoin.find(admin_office_matter_join.id).belong_side_id }
            end
          end
        end
      end
    end
  end

  describe 'DELET #destroy' do
    context '正常系' do
      context '案件管理事務所管理者でログイン' do
        context '案件ユーザー参加を削除' do
          it 'リクエストが成功すること' do
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to change(MatterJoin, :count).by(-1)
          end
        end
        context '案件管理ユーザー参加を削除' do
          it 'リクエストが成功すること' do
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, admin_user_matter_join.id)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, admin_user_matter_join.id)
            end.to change(MatterJoin, :count).by(-1)
          end
        end
        context '案件事務所参加を削除' do
          it 'リクエストが成功すること' do
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, office_matter_join.id)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, office_matter_join.id)
            end.to change(MatterJoin, :count).by(-1)
          end
        end
        context '案件管理事務所参加を削除' do
          it 'リクエストが成功すること' do
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, admin_office_matter_join.id)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, admin_office_matter_join.id)
            end.to change(MatterJoin, :count).by(-1)
          end
        end
      end
      context '案件管理個人ユーザーでログイン' do
        context '案件ユーザー参加を削除' do
          it 'リクエストが成功すること' do
            login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to change(MatterJoin, :count).by(-1)
          end
        end
      end
      context 'クライアント管理事務所管理者でログイン' do
        context '案件ユーザー参加を削除' do
          it 'リクエストが成功すること' do
            login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to change(MatterJoin, :count).by(-1)
          end
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        context '案件ユーザー参加を削除' do
          it 'リクエストが成功すること' do
            login_user(client_admin_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            login_user(client_admin_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to change(MatterJoin, :count).by(-1)
          end
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        context '案件ユーザー参加を削除' do
          it '401エラーが返ってくること' do
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 401
          end
          it '削除されないこと' do
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        context '案件ユーザー参加を削除' do
          it '403エラーが返ってくること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 403
          end
          it '削除されないこと' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context '案件管理事務所ユーザーでログイン' do
        context '案件ユーザー参加を削除' do
          it '403エラーが返ってくること' do
            login_user(matter_admin_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 403
          end
          it '削除されないこと' do
            login_user(matter_admin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context '案件参加ユーザーでログイン' do
        context '案件ユーザー参加を削除' do
          it '403エラーが返ってくること' do
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 403
          end
          it '削除されないこと' do
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '案件ユーザー参加を削除' do
          it '403エラーが返ってくること' do
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 403
          end
          it '削除されないこと' do
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context 'クライアント管理事務所ユーザーでログイン' do
        context '案件ユーザー参加を削除' do
          it '403エラーが返ってくること' do
            login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 403
          end
          it '削除されないこと' do
            login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '案件ユーザー参加を削除' do
          it '403エラーが返ってくること' do
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 403
          end
          it '削除されないこと' do
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to_not change(MatterJoin, :count)
          end
        end
      end

      context '案件管理事務所管理者でログイン' do
        context '案件管理事務所管理者を削除' do
          context '管理者数が１の状態' do
            before{
              MatterJoin.destroy_all
              ClientJoin.destroy_all
            }
            it '400エラーが返ってくること' do
              matter_join = create(:matter_join, matter: matter, office: matter_admin_office, user: nil, belong_side_id: '組織', admin: true)
              login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
              delete api_v1_matter_matter_join_path(matter, matter_join.id)
              expect(response).to have_http_status 400
            end
            it '削除されないこと' do
              matter_join = create(:matter_join, matter: matter, office: matter_admin_office, user: nil, belong_side_id: '組織', admin: true)
              login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
              expect do
                delete api_v1_matter_matter_join_path(matter, matter_join.id)
              end.to_not change(MatterJoin, :count)
            end
          end
        end
      end
      context '案件不ユーザー参加を削除' do
        context '案件ユーザー参加を削除' do
          it '403エラーが返ってくること' do
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 403
          end
          it '削除されないこと' do
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to_not change(MatterJoin, :count)
          end
        end
      end
      context '案件不参加事務所ユーザーを削除' do
        context '案件ユーザー参加を削除' do
          it '403エラーが返ってくること' do
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            expect(response).to have_http_status 403
          end
          it '削除されないこと' do
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_join_path(matter, user_matter_join.id)
            end.to_not change(MatterJoin, :count)
          end
        end
      end
    end
  end
end
