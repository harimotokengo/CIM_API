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
  let!(:injoin_belonging_info) { create(:belonging_info, user: injoin_user, office: injoin_office) }

  let!(:matter_category) { create(:matter_category) }
  let!(:pension_matter_category) { create(:matter_category, ancestry: '1', name: '年金') }

  let!(:client) { create(:client) }
  let!(:matter) { create(:matter, client: client) }
  let!(:matter_category_join) { create(:matter_category_join, matter: matter) }
  let!(:opponent) { create(:opponent, matter: matter) }
  let!(:office_matter_join) { create(:matter_join, matter: matter, office: matter_join_office, belong_side_id: '組織', admin: false) }
  let!(:admin_office_matter_join) { create(:matter_join, matter: matter, office: matter_admin_office, belong_side_id: '組織') }
  let!(:user_matter_join) { create(:matter_join, matter: matter, user: matter_join_user, belong_side_id: '個人', admin: false) }
  let!(:admin_user_matter_join) { create(:matter_join, matter: matter, user: matter_admin_user, belong_side_id: '個人') }
  let!(:office_lient_join) { create(:client_join, client: client, office: client_join_office, belong_side_id: '組織', admin: false) }
  let!(:admin_officeclient_join) { create(:client_join, client: client, office: client_admin_office, belong_side_id: '組織') }
  let!(:user_client_join) { create(:client_join, client: client, user: client_join_user, belong_side_id: '個人', admin: false, office: nil) }
  let!(:admin_user_client_join) { create(:client_join, client: client, user: client_admin_user, belong_side_id: '個人', office: nil) }

  describe 'POST #create' do
    context '正常系' do
      context '案件管理事務所管理者でログイン' do
        context '不参加ユーザーを登録' do
        end
        context '不参加事務所ユーザーを登録' do
        end
        context '案件参加事務所ユーザーを個人参加で登録' do
        end
        context 'クライアント参加事務所ユーザーを個人参加で登録' do
        end
        context '管理権限を付与' do
        end
      end
      context '案件管理個人ユーザーでログイン' do
        context '不参加ユーザーを登録' do
        end
        context '不参加事務所ユーザーを登録' do
        end
        context '案件参加事務所ユーザーを個人参加で登録' do
        end
        context 'クライアント参加事務所ユーザーを個人参加で登録' do
        end
        context '管理権限を付与' do
        end
      end
      context 'クライアント管理事務所ユーザーでログイン' do
        context '不参加ユーザーを登録' do
        end
        context '不参加事務所ユーザーを登録' do
        end
        context '案件参加事務所ユーザーを個人参加で登録' do
        end
        context 'クライアント参加事務所ユーザーを個人参加で登録' do
        end
        context '管理権限を付与' do
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        context '不参加ユーザーを登録' do
        end
        context '不参加事務所ユーザーを登録' do
        end
        context '案件参加事務所ユーザーを個人参加で登録' do
        end
        context 'クライアント参加事務所ユーザーを個人参加で登録' do
        end
        context '管理権限を付与' do
        end
      end
    end
    
    context '準正常系' do
      context '未ログイン' do
        context '不参加ユーザーを登録' do
        end
      end
      context '不参加ユーザーでログイン' do
        context '不参加ユーザーを登録' do
        end
      end
      context '不参加事務所管理者でログイン' do
        context '不参加ユーザーを登録' do
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        context '不参加ユーザーを登録' do
        end
      end
      context '案件参加ユーザーでログイン' do
        context '不参加ユーザーを登録' do
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '不参加ユーザーを登録' do
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '不参加ユーザーを登録' do
        end
      end
      context '案件管理事務所管理者でログイン' do
        context '案件参加ユーザーを登録' do
        end
        context '案件参加事務所ユーザーを登録' do
        end
        context 'クライアント参加ユーザーを登録' do
        end
        context 'クライアント参加事務所ユーザーを登録' do
        end
        context '不参加ユーザーを登録' do
          context 'パラメータが不正' do
          end
        end
      end
    end
  end
end
