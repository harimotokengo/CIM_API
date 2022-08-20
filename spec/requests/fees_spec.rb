require 'rails_helper'

RSpec.describe 'fees_requests', type: :request do
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
  let!(:matter_join_office_admin) { create(:user) }
  let!(:matter_admin_office_user) { create(:user) }
  let!(:matter_admin_office_admin) { create(:user) }
  let!(:injoin_user) { create(:user) }
  let!(:injoin_office_user) { create(:user) }
  let!(:injoin_office_other) { create(:user) }

  let!(:client_join_office_user_belonging_info) { create(:belonging_info, user: client_join_office_user, office: client_join_office) }
  let!(:client_admin_office_user_belonging_info) { create(:belonging_info, user:client_admin_office_user, office:client_admin_office) }
  let!(:client_admin_office_admin_belonging_info) { create(:belonging_info, user: client_admin_office_admin, office: client_admin_office, admin: true) }
  let!(:matter_join_office_user_belonging_info) { create(:belonging_info, user: matter_join_office_user, office: matter_join_office, admin: true) }
  let!(:matter_join_office_other_belonging_info) { create(:belonging_info, user: matter_join_office_admin, office: matter_join_office) }
  let!(:matter_admin_office_user_belonging_info) { create(:belonging_info, user: matter_admin_office_user, office:matter_join_office) }
  let!(:matter_admin_office_admin_belonging_info) { create(:belonging_info, user: matter_admin_office_admin, office: matter_admin_office, admin: true) }
  let!(:injoin_belonging_info) { create(:belonging_info, user: injoin_office_user, office: injoin_office, admin: true) }
  let!(:injoin_other_belonging_info) { create(:belonging_info, user: injoin_office_other, office: injoin_office) }

  let!(:matter_category) { create(:matter_category) }
  let!(:pension_matter_category) { create(:matter_category, ancestry: '1', name: '年金') }

  let!(:work_stage) { create(:work_stage) }
  let!(:task) { create(:task, name: 'タスク',matter: nil, user: matter_join_office_user) }
  let!(:matter_task) { create(:task, name: '案件タスク', matter: matter, user: matter_join_office_user) }
  let!(:fee) { create(:fee, matter: matter, task: matter_task) }

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
  
  describe 'POST #create' do
    context '正常系' do
      context '案件参加ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          fee_params = attributes_for(:fee, matter_id: matter.id, task_id: matter_task.id)
          post api_v1_fees_path, params: { fee: fee_params }
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          fee_params = attributes_for(:fee, matter_id: matter.id, task_id: matter_task.id)
          expect do
            post api_v1_fees_path, params: { fee: fee_params }
          end.to change(Fee, :count).by(1)
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーを返すこと' do
          fee_params = attributes_for(:fee, matter_id: matter.id, task_id: matter_task.id)
          post api_v1_fees_path, params: { fee: fee_params }
          expect(response).to have_http_status 401
        end
        it '登録されない' do
          fee_params = attributes_for(:fee, matter_id: matter.id, task_id: matter_task.id)
          expect do
            post api_v1_fees_path, params: { fee: fee_params }
          end.to_not change(Fee, :count)
        end
      end
      context 'パラメーターが無効な場合' do
        it '400エラーを返すこと' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          fee_params = attributes_for(:fee, matter_id: matter.id, price: '')
          post api_v1_fees_path, params: { fee: fee_params }
          expect(response).to have_http_status 400
        end
        it '登録されない' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          fee_params = attributes_for(:fee, matter_id: matter.id, price: '')
          expect do
            post api_v1_fees_path, params: { fee: fee_params }
          end.to_not change(Fee, :count)
        end
      end
    end
  end

  describe 'PUT #update' do
    context '正常系' do
      context '案件参加ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          fee_params = attributes_for(:fee, price: 10)
          put api_v1_fee_path(fee), params: { fee: fee_params }
          expect(response).to have_http_status 200
        end
        it '更新されること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          fee_params = attributes_for(:fee, price: 10)
          expect do
            put api_v1_fee_path(fee), params: { fee: fee_params }
          end.to change { Fee.find(fee.id).price }.from(1_000_000).to(10)
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーを返すこと' do
          fee_params = attributes_for(:fee, price: 10)
          put api_v1_fee_path(fee), params: { fee: fee_params }
          expect(response).to have_http_status 401
        end
        it '登録されない' do
          fee_params = attributes_for(:fee, price: 10)
          expect do
            put api_v1_fee_path(fee), params: { fee: fee_params }
          end.to_not change(Fee, :count)
        end
      end
      context 'パラメータが無効' do
        it '400エラーを返すこと' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          fee_params = attributes_for(:fee, price: '')
          put api_v1_fee_path(fee), params: { fee: fee_params }
          expect(response).to have_http_status 400
        end
        it '登録されない' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          fee_params = attributes_for(:fee, matter_id: matter.id, price: '')
          expect do
            put api_v1_fee_path(fee), params: { fee: fee_params }
          end.to_not change(Fee, :count)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context '正常系' do
      context'案件管理ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          delete api_v1_fee_path(fee)
          expect(response).to have_http_status 200
        end
        it 'アーカイブされること' do
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_fee_path(fee)
          end.to change {Fee.find(fee.id).archive}.from(true).to(false)
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーを返すこと' do
          delete api_v1_fee_path(fee)
          expect(response).to have_http_status 401
        end
        it 'アーカイブされない' do
          expect do
            delete api_v1_fee_path(fee)
          end.to_not change {Fee.find(fee.id).archive}
        end
      end
      context '権限のないユーザーでログイン' do
        it '403エラーを返すこと' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          delete api_v1_fee_path(fee)
          expect(response).to have_http_status 403
        end
        it 'アーカイブされない' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_fee_path(fee)
          end.to_not change {Fee.find(fee.id).archive}
        end
      end
    end
  end
end