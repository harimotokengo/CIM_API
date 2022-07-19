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
  let!(:user_matter_join) { create(:matter_join, matter: matter, user: matter_join_user, belong_side_id: '個人', admin: false, office_id: nil) }
  let!(:admin_user_matter_join) { create(:matter_join, matter: matter, user: matter_admin_user, belong_side_id: '個人', office_id: nil) }
  let!(:office_client_join) { create(:client_join, client: client, office: client_join_office, belong_side_id: '組織', admin: false) }
  let!(:admin_office_client_join) { create(:client_join, client: client, office: client_admin_office, belong_side_id: '組織') }
  let!(:user_client_join) { create(:client_join, client: client, user: client_join_user, belong_side_id: '個人', admin: false, office_id: nil) }
  let!(:admin_user_client_join) { create(:client_join, client: client, user: client_admin_user, belong_side_id: '個人', office_id: nil) }

  describe 'GET #index' do
    context '正常系' do
      context '案件参加事務所ユーザーでログイン' do
      end
      context '案件参加ユーザーでログイン' do
      end
      context 'クラアント参加事務所ユーザーでログイン' do
      end
      context 'クライアントユーザーでログイン' do
      end
    end
    context '準正常系' do
      context '未ログイン' do
      end
      context '不参加ユーザーでログイン' do
      end
      context '不参加事務所管理者でログイン' do
      end
    end
  end

  describe 'POST #create_token' do
    context '正常系' do
      context '案件管理事務所管理者でログイン' do
      end
      context '案件管理個人ユーザーでログイン' do
      end
      context 'クライアント管理事務所ユーザーでログイン' do
      end
      context 'クライアント管理個人ユーザーでログイン' do
      end
    end
    context '準正常系' do
      context '未ログイン' do
      end
      context '不参加ユーザーでログイン' do
      end
      context '不参加事務所管理者でログイン' do
      end
      context '案件参加事務所ユーザーでログイン' do
      end
      context '案件参加ユーザーでログイン' do
      end
      context 'クライアント参加事務所ユーザーでログイン' do
      end
      context 'クライアント参加ユーザーでログイン' do
      end
      context '案件管理事務所管理者でログイン' do
        context 'パラメータが不正' do
        end
      end
    end
  end

  describe 'GET #get_invite_url' do
    context '正常系' do
      context '案件管理事務所管理者でログイン' do
      end
      context '案件管理個人ユーザーでログイン' do
      end
      context 'クライアント管理事務所ユーザーでログイン' do
      end
      context 'クライアント管理個人ユーザーでログイン' do
      end
    end
    context '準正常系' do
      context '未ログイン' do
      end
      context '不参加ユーザーでログイン' do
      end
      context '不参加事務所管理者でログイン' do
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
  end

  describe 'POST #create' do
    context '正常系' do
      context '不参加ユーザーでログイン' do
        context '組織で参加' do
        end
        context '個人で参加' do
        end
      end
      context '不参加事務所ユーザーでログイン' do
        context '組織で参加' do
        end
        context '個人で参加' do
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        context '個人で参加' do
        end
      end
      context '案件参加ユーザーでログイン' do
        context '組織で参加' do
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '個人で参加' do
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '組織で参加' do
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
      end
      context '案件参加ユーザーでログイン' do
      end
      context '案件参加事務所ユーザーでログイン' do
        context '組織で参加' do
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '個人で参加' do
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '組織で参加' do
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '組織で参加' do
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '個人で参加' do
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

  describe 'PUT #update' do
    context '正常系' do
      context '案件管理事務所管理者でログイン' do
        context '案件参加ユーザーを更新' do
        end
        context '案件管理ユーザーを更新' do
        end
        context '案件参加事務所ユーザーを更新' do
        end
        context '案件管理事務所ユーザーを更新' do
        end
        context 'クライアント参加ユーザーを更新' do
        end
        context 'クライアント管理ユーザーを更新' do
        end
        context 'クライアント参加事務所ユーザーを更新' do
        end
        context 'クライアント管理事務所管理者を更新' do
        end
      end
      context '案件管理個人ユーザーでログイン' do
        context '案件参加ユーザーを更新' do
        end
      end
      context 'クライアント管理事務所ユーザーでログイン' do
        context '案件参加ユーザーを更新' do
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        context '案件参加ユーザーを更新' do
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        context '案件参加ユーザーを更新' do
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        context '案件参加ユーザーを更新' do
        end
      end
      context '案件管理事務所ユーザーでログイン' do
        context '案件参加ユーザーを更新' do
        end
      end
      context '案件参加ユーザーでログイン' do
        context '案件参加ユーザーを更新' do
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '案件参加ユーザーを更新' do
        end
      end
      context 'クライアント管理事務所ユーザーでログイン' do
        context '案件参加ユーザーを更新' do
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '案件参加ユーザーを更新' do
        end
      end

      context '案件管理事務所管理者でログイン' do
        context '案件管理事務所管理者を更新' do
          context '管理者数が1の状態でadmin権限を解除' do
          end
          context 'パラメータが不正' do
          end
        end
        context '案件不参加ユーザーを更新' do
        end
        context '案件不参加事務所ユーザーを更新' do
        end
      end
    end
  end

  describe 'DELET #destroy' do
    context '正常系' do
      context '案件管理事務所管理者でログイン' do
        context '案件参加ユーザーを削除' do
        end
        context '案件管理ユーザーを削除' do
        end
        context '案件参加事務所ユーザーを削除' do
        end
        context '案件管理事務所ユーザーを削除' do
        end
        context 'クライアント参加ユーザーを削除' do
        end
        context 'クライアント管理ユーザーを削除' do
        end
        context 'クライアント参加事務所ユーザーを削除' do
        end
        context 'クライアント管理事務所管理者を削除' do
        end
      end
      context '案件管理個人ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
        end
      end
      context 'クライアント管理事務所ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        context '案件参加ユーザーを削除' do
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
        end
      end
      context '案件管理事務所ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
        end
      end
      context '案件参加ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
        end
      end
      context 'クライアント管理事務所ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
        end
      end

      context '案件管理事務所管理者でログイン' do
        context '案件管理事務所管理者を削除' do
          context '管理者数が１の状態' do
          end
        end
        context '案件不参加ユーザーを削除' do
        end
        context '案件不参加事務所ユーザーを削除' do
        end
      end
    end
  end
end
