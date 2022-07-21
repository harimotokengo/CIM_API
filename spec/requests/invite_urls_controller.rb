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
            login_user(belonging_info.user, 'Test-1234', login_path)
            get invite_url_path(invite_url, tk: '0123456789abcdef')
            expect(response).to have_http_status 200
          end
          it '参加画面情報' do

        end
        context '不参加事務所ユーザーでログイン' do
        end
        context '案件参加事務所ユーザーでログイン' do
        end
        context '案件参加ユーザーでログイン' do
        end
        context 'クライアント参加事務所ユーザーでログイン' do
        end
        context 'クライアント参加ユーザーでログイン' do
        end
      end
      context 'クライアント参加' do
        context '不参加ユーザーでログイン' do
        end
        context '不参加事務所ユーザーでログイン' do
        end
        context 'クライアント参加事務所ユーザーでログイン' do
        end
        context 'クライアント参加ユーザーでログイン' do
        end
      end

      # it 'ログイン状態でのリクエストが成功すること' do
      #   login_user(belonging_info.user, 'Test-1234', login_path)
      #   get invite_url_path(invite_url, tk: '0123456789abcdef')
      #   expect(response).to have_http_status 200
      # end
      # it '同じ事務所のuserのログイン状態でのリクエストが成功すること' do
      #   login_user(belonging_info2.user, 'Test-1234', login_path)
      #   get invite_url_path(invite_url, tk: '0123456789abcdef')
      #   expect(response).to have_http_status 200
      # end
      # it '他事務所でも参加済みの人がログイン状態の場合リクエストが成功すること' do
      #   login_user(other_belonging_info.user, 'Test-1234', login_path)
      #   get invite_url_path(invite_url, tk: '0123456789abcdef')
      #   expect(response.status).to eq 200
      # end
      # it '参加がない状態でもリクエストが成功すること' do
      #   login_user(other_belonging_info2.user, 'Test-1234', login_path)
      #   get invite_url_path(invite_url, tk: '0123456789abcdef')
      #   expect(response.status).to eq 200
      # end
    end
    context '準正常系' do
      context '未ログイン' do
      end
      context '不参加ユーザーでログイン' do
        context '招待URLが不正' do
        end
        context 'tokenが期限切れ' do
        end
        context 'tokenがアクセス済み' do
        end
      end



      # it 'ログアウト状態だとログインページにリダイレクトされること' do
      #   get invite_url_path(invite_url, tk: '0123456789abcdef')
      #   expect(response).to have_http_status 302
      #   expect(response).to redirect_to login_path
      # end
      # xit 'officeの登録がない場合、〇〇にリダイレクトされること' do
      #   # login_user(belonging_info.user, 'Test-1234', login_path)
      #   get invite_url_path(invite_url, tk: '0123456789abcdef')
      #   expect(response).to have_http_status 302
      #   # expect(response).to redirect_to login_path
      # end
      # it 'トークンが一致しないとuser/showにリダイレクトされること' do
      #   login_user(other_belonging_info2.user, 'Test-1234', login_path)
      #   get invite_url_path(invite_url, tk: '01234567d9abcdef')
      #   expect(response).to have_http_status 302
      #   expect(response).to redirect_to user_path(other_user2)
      # end
      # it '期限切れの場合user/showにリダイレクトされること（2日前）' do
      #   login_user(other_belonging_info2.user, 'Test-1234', login_path)
      #   get invite_url_path(invite_url2, tk: '0123456789abcdef')
      #   expect(response).to have_http_status 302
      #   expect(response).to redirect_to user_path(other_user2)
      # end
    end
  end
end