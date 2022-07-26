require 'rails_helper'

RSpec.describe 'tasks_requests', type: :request do
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

  let!(:work_stage) { create(:work_stage) }
  let!(:task) { create(:task) }

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
        context '案件タスクを作成' do
          it 'リクエストが成功すること' do
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            post api_v1_tasks_path, params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_tasks_path, params: { task: task_params}
            end.to change(Task, :count).by(1)
          end
        end
        context 'タスクを作成' do
          it 'リクエストが成功すること' do
            task_params = attributes_for(:task, work_stage_id: work_stage.id)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            post api_v1_tasks_path, params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            task_params = attributes_for(:task, work_stage_id: work_stage.id)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_tasks_path, params: { task: task_params}
            end.to change(Task, :count).by(1)
          end
        end
        context 'タスク担当を入力' do
          it 'リクエストが成功すること' do
            task_assign_params = {task_assigns_attributes: { "0": attributes_for(:task_assign, user_id: matter_join_user.id)}}
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id).merge(task_assign_params)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            post api_v1_tasks_path, params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            task_assign_params = {task_assigns_attributes: { "0": attributes_for(:task_assign, user_id: matter_join_user.id)}}
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id).merge(task_assign_params)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_tasks_path, params: { task: task_params}
            end.to change(Task, :count).by(1).and change(TaskAssign, :count).by(1)
          end
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        context '案件タスクを作成' do
          it 'リクエストが成功すること' do
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            post api_v1_tasks_path, params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_tasks_path, params: { task: task_params}
            end.to change(Task, :count).by(1)
          end
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '案件タスクを作成' do
          it 'リクエストが成功すること' do
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            post api_v1_tasks_path, params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_tasks_path, params: { task: task_params}
            end.to change(Task, :count).by(1)
          end
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '案件タスクを作成' do
          it 'リクエストが成功すること' do
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            post api_v1_tasks_path, params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_tasks_path, params: { task: task_params}
            end.to change(Task, :count).by(1)
          end
        end
      end
      context '案件不参加ユーザーでログイン' do
        context 'タスクを作成' do
          it 'リクエストが成功すること' do
            task_params = attributes_for(:task, work_stage_id: work_stage.id)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            post api_v1_tasks_path, params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            task_params = attributes_for(:task, work_stage_id: work_stage.id)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_tasks_path, params: { task: task_params}
            end.to change(Task, :count).by(1)
          end
        end
      end
      context '案件不参加事務所ユーザーでログイン' do
        context 'タスクを作成' do
          it 'リクエストが成功すること' do
            task_params = attributes_for(:task, work_stage_id: work_stage.id)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            post api_v1_tasks_path, params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            task_params = attributes_for(:task, work_stage_id: work_stage.id)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              post api_v1_tasks_path, params: { task: task_params}
            end.to change(Task, :count).by(1)
          end
        end
      end
    end
  end
end
