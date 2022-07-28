require 'rails_helper'

RSpec.describe 'task_template_groups_requests', type: :request do
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
          task_template_params = {task_templates_attributes: { "0": attributes_for(:task_template, work_stage_id: work_stage.id)}}
          task_template_group_params = attributes_for(:task_template_group, user_id: matter_join_office_user.id,matter_category_id: matter_category.id).merge(task_template_params)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          post api_v1_task_templates_path, params: { task_template_group: task_template_group_params }
          expect(response).to have_http_status 200
        end
        it '登録できること' do
          task_template_params = {task_templates_attributes: { "0": attributes_for(:task_template, work_stage_id: work_stage.id)}}
          task_template_group_params = attributes_for(:task_template_group, user_id: matter_join_office_user.id,matter_category_id: matter_category.id).merge(task_template_params)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_task_templates_path, params: { task_template_group: task_template_group_params }
          end.to change(TaskTemplateGroup, :count).by(1).and change(TaskTemplate, :count).by(1)
        end
      end
    end
  end

  describe 'PUT #update' do
    context '正常系' do
      context '登録ユーザーでログイン' do
        it 'リクエストが成功すること' do
          task_template_group_params = attributes_for(:task_template_group, name: '更新',user_id: matter_join_office_user.id,matter_category_id: matter_category.id)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          put api_v1_task_template_path(task_template_group), params: { task_template_group: task_template_group_params }
          expect(response).to have_http_status 200
        end
        it '更新されること' do
          task_template_group_params = attributes_for(:task_template_group, name: '更新',user_id: matter_join_office_user.id,matter_category_id: matter_category.id)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            put api_v1_task_template_path(task_template_group), params: { task_template_group: task_template_group_params }
          end.to change {TaskTemplateGroup.find(task_template_group.id).name}.from('タスクテンプレート群').to('更新')
        end
        it '子モデルが更新されること' do
          task_template_params = {task_templates_attributes: { "0": attributes_for(:task_template, id: task_template.id ,name: '更新', work_stage_id: work_stage.id)}}
          task_template_group_params = attributes_for(:task_template_group,user_id: matter_join_office_user.id,matter_category_id: matter_category.id).merge(task_template_params)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            put api_v1_task_template_path(task_template_group), params: { task_template_group: task_template_group_params }
          end.to change {TaskTemplate.find(task_template.id).name}.from('タスクテンプレート').to('更新')
        end
      end
      context '登録ユーザーと同事務所管理者でログイン' do
        it 'リクエストが成功すること' do
          task_template_group = create(:task_template_group, name: 'タスクテンプレート群',user: matter_join_office_user)
          task_template_group_params = attributes_for(:task_template_group, name: '更新',user_id: matter_join_office_user.id,matter_category_id: matter_category.id)
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          put api_v1_task_template_path(task_template_group), params: { task_template_group: task_template_group_params }
          expect(response).to have_http_status 200
        end
        it '更新されること' do
          task_template_group_params = attributes_for(:task_template_group, name: '更新',user_id: matter_join_office_user.id,matter_category_id: matter_category.id)
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          expect do
            put api_v1_task_template_path(task_template_group), params: { task_template_group: task_template_group_params }
          end.to change {TaskTemplateGroup.find(task_template_group.id).name}.from('タスクテンプレート群').to('更新')
        end
        it '子モデルが更新されること' do
          task_template_params = {task_templates_attributes: { "0": attributes_for(:task_template, id: task_template.id ,name: '更新', work_stage_id: work_stage.id)}}
          task_template_group_params = attributes_for(:task_template_group,user_id: matter_join_office_user.id,matter_category_id: matter_category.id).merge(task_template_params)
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          expect do
            put api_v1_task_template_path(task_template_group), params: { task_template_group: task_template_group_params }
          end.to change {TaskTemplate.find(task_template.id).name}.from('タスクテンプレート').to('更新')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context '正常系' do
      context '登録ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          delete api_v1_task_template_path(task_template_group)
          expect(response).to have_http_status 200
        end
        it 'アーカイブされること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_task_template_path(task_template_group)
          end.to change {TaskTemplateGroup.find(task_template_group.id).archive}.from(true).to(false)
        end
      end
      context '登録ユーザーと同事務所管理者でログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          delete api_v1_task_template_path(task_template_group)
          expect(response).to have_http_status 200
        end
        it 'アーカイブされること' do
          login_user(matter_join_office_admin, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_task_template_path(task_template_group)
          end.to change {TaskTemplateGroup.find(task_template_group.id).archive}.from(true).to(false)
        end
      end
    end
  end
end