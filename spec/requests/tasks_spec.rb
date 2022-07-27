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
            binding.pry
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

  describe 'PUT #update' do
    context '正常系' do
      context '案件参加事務所ユーザーでログイン' do
        context '案件タスクを更新' do
          it 'リクエストが成功すること'do
            task_params = attributes_for(:task, name: '更新', matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_task_path(matter_task), params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            task_params = attributes_for(:task, name: '更新', matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_task_path(matter_task), params: { task: task_params}
            end.to change {Task.find(matter_task.id).name }.from('案件タスク').to('更新')
          end
        end
        context 'タスクを更新' do
          it 'リクエストが成功すること'do
            task_params = attributes_for(:task, name: '更新', work_stage_id: work_stage.id)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_task_path(task), params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            task_params = attributes_for(:task, name: '更新', work_stage_id: work_stage.id)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_task_path(task), params: { task: task_params}
            end.to change {Task.find(task.id).name }.from('タスク').to('更新')
          end
        end
        context 'タスク担当を入力して案件タスクを更新' do
          it 'リクエストが成功すること'do
            task_assign_params = {task_assigns_attributes: { "0": attributes_for(:task_assign, user_id: matter_join_user.id)}}
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id).merge(task_assign_params)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_task_path(matter_task), params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            task_assign_params = {task_assigns_attributes: { "0": attributes_for(:task_assign, user_id: matter_join_user.id)}}
            task_params = attributes_for(:task, matter_id: matter.id, work_stage_id: work_stage.id).merge(task_assign_params)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_task_path(matter_task), params: { task: task_params}
            end.to change(TaskAssign, :count).by(1)
          end
        end
      end
      context '案件参加ユーザーでログイン' do
        context '案件タスクを更新' do
          it 'リクエストが成功すること'do
            task_params = attributes_for(:task, name: '更新', matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            put api_v1_task_path(matter_task), params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            task_params = attributes_for(:task, name: '更新', matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_task_path(matter_task), params: { task: task_params}
            end.to change {Task.find(matter_task.id).name }.from('案件タスク').to('更新')
          end
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '案件タスクを更新' do
          it 'リクエストが成功すること'do
            task_params = attributes_for(:task, name: '更新', matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            put api_v1_task_path(matter_task), params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            task_params = attributes_for(:task, name: '更新', matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_task_path(matter_task), params: { task: task_params}
            end.to change {Task.find(matter_task.id).name }.from('案件タスク').to('更新')
          end
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '案件タスクを更新' do
          it 'リクエストが成功すること'do
            task_params = attributes_for(:task, name: '更新', matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_task_path(matter_task), params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            task_params = attributes_for(:task, name: '更新', matter_id: matter.id, work_stage_id: work_stage.id)
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_task_path(matter_task), params: { task: task_params}
            end.to change {Task.find(matter_task.id).name }.from('案件タスク').to('更新')
          end
        end
      end
      context '案件不参加ユーザーでログイン' do
        context '作成したタスクを更新' do
          it 'リクエストが成功すること'do
            injoin_user_task = create(:task, name: 'タスク',matter: nil, user: injoin_user)
            task_params = attributes_for(:task, name: '更新', work_stage_id: work_stage.id)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            put api_v1_task_path(injoin_user_task), params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            injoin_user_task = create(:task, name: 'タスク',matter: nil, user: injoin_user)
            task_params = attributes_for(:task, name: '更新', work_stage_id: work_stage.id)
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_task_path(injoin_user_task), params: { task: task_params}
            end.to change {Task.find(injoin_user_task.id).name }.from('タスク').to('更新')
          end
        end
      end
      context '案件不参加事務所ユーザーでログイン' do
        context '同事務所ユーザーが作成したタスクを更新' do
          it 'リクエストが成功すること'do
            injoin_office_task = create(:task, name: 'タスク',matter: nil, user: injoin_office_other)
            task_params = attributes_for(:task, name: '更新', work_stage_id: work_stage.id)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            put api_v1_task_path(injoin_office_task), params: { task: task_params}
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            injoin_office_task = create(:task, name: 'タスク',matter: nil, user: injoin_office_other)
            task_params = attributes_for(:task, name: '更新', work_stage_id: work_stage.id)
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            expect do
              put api_v1_task_path(injoin_office_task), params: { task: task_params}
            end.to change {Task.find(injoin_office_task.id).name }.from('タスク').to('更新')
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context '正常系' do
      context 'タスク作成者でログイン' do
        it 'リクエストが成功すること'do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          delete api_v1_task_path(matter_task)
          expect(response).to have_http_status 200
        end
        it 'アーカイブされること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_task_path(matter_task)
          end.to change {Task.find(matter_task.id).archive}.from(true).to(false)
        end
      end
      context 'タスク作成者と同事務所の管理者でログイン' do
        it 'リクエストが成功すること'do
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          delete api_v1_task_path(matter_task)
          expect(response).to have_http_status 200
        end
        it 'アーカイブされること' do
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_task_path(matter_task)
          end.to change {Task.find(matter_task.id).archive}.from(true).to(false)
        end
      end
    end
  end
end
