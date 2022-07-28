require 'rails_helper'

RSpec.describe 'work_stages_requests', type: :request do
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
  let!(:task_template_group) { create(:task_template_group, name: 'タスクテンプレート群',user: matter_join_office_user) }
  let!(:task_template) { create(:task_template, name: 'タスクテンプレート', task_template_group_id: task_template_group.id) }

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
      context 'ログイン状態' do
        it 'リクエストが成功すること' do
          work_stage_params = attributes_for(:work_stage, user_id: matter_join_office_user.id, matter_category_id: matter_category.id)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          post api_v1_work_stages_path, params: { work_stage: work_stage_params }
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          work_stage_params = attributes_for(:work_stage, user_id: matter_join_office_user.id, matter_category_id: matter_category.id)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_work_stages_path, params: { work_stage: work_stage_params }
          end.to change(WorkStage, :count).by(1)
        end
      end
    end
  end

  describe 'PUT #update' do
    let!(:update_work_stage) { create(:work_stage, name: '作業段階', user: matter_join_office_user) }
    context '正常系' do
      context '登録ユーザーでログイン' do
        it 'リクエストが成功すること' do
          work_stage_params = attributes_for(:work_stage, name: '更新', user_id: matter_join_office_user.id, matter_category_id: matter_category.id)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          put api_v1_work_stage_path(update_work_stage), params: { work_stage: work_stage_params }
          expect(response).to have_http_status 200
        end
        it '更新されること' do
          work_stage_params = attributes_for(:work_stage, name: '更新', user_id: matter_join_office_user.id, matter_category_id: matter_category.id)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            put api_v1_work_stage_path(update_work_stage), params: { work_stage: work_stage_params }
          end.to change {WorkStage.find(update_work_stage.id).name}.from('作業段階').to('更新')
        end
      end
      context '登録ユーザーと同事務所のでログイン' do
        it 'リクエストが成功すること' do
          work_stage_params = attributes_for(:work_stage, name: '更新', user_id: matter_join_office_user.id, matter_category_id: matter_category.id)
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          put api_v1_work_stage_path(update_work_stage), params: { work_stage: work_stage_params }
          expect(response).to have_http_status 200
        end
        it '更新されること' do
          work_stage_params = attributes_for(:work_stage, name: '更新', user_id: matter_join_office_user.id, matter_category_id: matter_category.id)
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          expect do
            put api_v1_work_stage_path(update_work_stage), params: { work_stage: work_stage_params }
          end.to change {WorkStage.find(update_work_stage.id).name}.from('作業段階').to('更新')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:destroy_work_stage) { create(:work_stage, user: matter_join_office_user) }
    context '正常系' do
      context '登録ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          delete api_v1_work_stage_path(destroy_work_stage)
          expect(response).to have_http_status 200
        end
        it 'アーカイブされること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_work_stage_path(destroy_work_stage)
          end.to change {WorkStage.find(destroy_work_stage.id).archive}.from(true).to(false)
        end
      end
      context '登録ユーザーと同事務所管理者でログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          delete api_v1_work_stage_path(destroy_work_stage)
          expect(response).to have_http_status 200
        end
        it 'アーカイブされること' do
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_work_stage_path(destroy_work_stage)
          end.to change {WorkStage.find(destroy_work_stage.id).archive}.from(true).to(false)
        end
      end
    end
  end
end