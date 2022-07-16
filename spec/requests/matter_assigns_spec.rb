require 'rails_helper'

RSpec.describe 'matter_assigns_requests', type: :request do
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
  
  # let!(:matter_assign) { create(:matter_assign, matter: matter, user: user) }
  # let!(:matter_assign) { create(:matter_assign, matter: matter, user: user) }


  describe 'POST #create' do
    context '正常系' do
      context '案件参加事務所ユーザーでログイン' do
        context '自身を登録' do
          it 'リクエストが成功すること' do
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 200
          end
        end
      end
    end
  end
end
