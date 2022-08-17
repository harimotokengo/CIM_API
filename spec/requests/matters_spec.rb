require 'rails_helper'

RSpec.describe 'matters_requests', type: :request do
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

  let!(:task_template_group) { create(:task_template_group, name: 'タスクテンプレート群', public_flg: true) }
  let!(:task_template) { create(:task_template, name: 'タスクテンプレート', task_template_group_id: task_template_group.id) }

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
  
  let!(:client_join_office_user_belonging_info) { create(:belonging_info, user: client_join_office_user, office: client_join_office) }
  let!(:client_admin_office_user_belonging_info) { create(:belonging_info, user:client_admin_office_user, office:client_admin_office) }
  let!(:client_admin_office_admin_belonging_info) { create(:belonging_info, user: client_admin_office_admin, office: client_admin_office, admin: true) }
  let!(:matter_join_office_user_belonging_info) { create(:belonging_info, user: matter_join_office_user, office: matter_join_office) }
  let!(:matter_admin_office_user_belonging_info) { create(:belonging_info, user: matter_join_office_user, office:matter_join_office) }
  let!(:matter_admin_office_admin_belonging_info) { create(:belonging_info, user: matter_admin_office_admin, office: matter_admin_office, admin: true) }

  let!(:injoin_belonging_info) { create(:belonging_info, user: injoin_user, office: injoin_office) }

  describe 'GET #index' do
    context '正常系' do
      context '案件参加ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          get api_v1_matters_path
          expect(response).to have_http_status 200
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          get api_v1_matters_path
          expect(response).to have_http_status 200
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(client_join_user, 'Test-1234', api_v1_login_path)
          get api_v1_matters_path
          expect(response).to have_http_status 200
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(client_join_user, 'Test-1234', api_v1_login_path)
          get api_v1_matters_path
          expect(response).to have_http_status 200
        end
      end
      context '不参加事務所ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          get api_v1_matters_path
          expect(response).to have_http_status 200
          expect(JSON.parse(response.body)['data'].count).to eq 0
        end
      end
      context '不参加事務所ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          get api_v1_matters_path
          expect(response).to have_http_status 200
          expect(JSON.parse(response.body)['data'].count).to eq 0
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          get api_v1_matters_path
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
    end
  end
  # ログ未実装
  # 登録者または登録者の事務所がmatter_joinのadminに登録される
  # 個人は組織でjoinできないこと
  describe 'POST #create' do
    before do
      contact_phone_number_params = {contact_phone_numbers_attributes: { "0": attributes_for(:contact_phone_number)}}
      invalid_contact_phone_number_params = { contact_phone_numbers_attributes: {"0": attributes_for(:contact_phone_number, phone_number: '123456') }}
      contact_email_params = { contact_emails_attributes: { "0": attributes_for(:contact_email) }  }
      contact_address_params = { contact_addresss_attributes: {  "0": attributes_for(:contact_address)}}
      @opponent_params = {opponents_attributes: { "0": attributes_for(:opponent)}}
      @contact_opponent_params = {opponents_attributes: { "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params) }}
      @matter_category_join_params = {matter_category_joins_attributes: { "0": attributes_for(:matter_category_join) }}
      
      # @matter_admin_user_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, user_id: session[:user_id], belong_side_id: '個人', office: nil) }}
      # @matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(opponent_params, matter_join_params) } }
      # @min_matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(matter_join_params) }}
      # @contact_matter_params = {matters_attributes: { "0": attributes_for(:matter, user_id: user.id).merge(contact_opponent_params, matter_join_params)}}
      
    end
    context '正常系' do
      context 'クライアント管理事務所ユーザーでログイン' do
        before {
          login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
          @matter_join_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, office_id: User.find(session[:user_id]).belonging_office) }}
        }
        context '案件、相手方等、相手方連絡先を入力' do
          before do
            @matter_params = attributes_for(:matter, task_template_group_id: task_template_group.id
              ).merge(@matter_join_params, @contact_opponent_params, @matter_category_join_params)
          end
          it 'リクエストが成功すること' do
            post api_v1_client_matters_path(client), params: { matter: @matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            expect do
              post api_v1_client_matters_path(client), params: { matter: @matter_params }
            end.to change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(
              ContactEmail, :count).by(1) and change(ContactAddress, :count).by(1) and change(
                ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1) and change(
                  Task, :count).by(1)
          end
        end
        context '案件のみ入力' do
          before do
            @matter_params = attributes_for(:matter, task_template_group_id: task_template_group.id
              ).merge(@matter_join_params, @matter_category_join_params)
          end
          it 'リクエストが成功すること' do
            post api_v1_client_matters_path(client), params: { matter: @matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            expect do
              post api_v1_client_matters_path(client), params: { matter: @matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1) and change(
              Task, :count).by(1)
          end
        end
        context '案件と案件タグを入力' do
          before do
            @matter_params = attributes_for(:matter, task_template_group_id: task_template_group.id, tag_name: '案件タグ'
              ).merge(@matter_join_params)
          end
          it '登録されること' do
            expect do
              post api_v1_client_matters_path(client), params: { matter: @matter_params }
            end.to change(Matter, :count).by(1) and change(
              MatterJoin, :count).by(1) and change(MatterTag, :count).by(1) and change(
                Task, :count).by(1)
          end
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        before{
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          @matter_join_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, user_id: session[:user_id], belong_side_id: '個人', office: nil) }}
        }
        context '案件、相手方等、相手方連絡先を入力' do
          before{@matter_params = attributes_for(:matter, task_template_group_id: task_template_group.id
            ).merge(@matter_join_params, @contact_opponent_params, @matter_category_join_params)}
          it 'リクエストが成功すること' do
            post api_v1_client_matters_path(client), params: { matter: @matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            expect do
              post api_v1_client_matters_path(client), params: { matter: @matter_params }
            end.to change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(
              ContactEmail, :count).by(1) and change(ContactAddress, :count).by(1) and change(
                ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1) and change(
                  Task, :count).by(1)
          end
        end
        context '案件のみ入力' do
          before{@matter_params = attributes_for(:matter, task_template_group_id: task_template_group.id
          ).merge(@matter_join_params, @matter_category_join_params)}
          it 'リクエストが成功すること' do
            post api_v1_client_matters_path(client), params: { matter: @matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            expect do
              post api_v1_client_matters_path(client), params: { matter: @matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1) and change(
              Task, :count).by(1)
          end
        end
        context '案件と案件タグを入力' do
          before{@matter_params = attributes_for(:matter, task_template_group_id: task_template_group.id, tag_name: '案件タグ'
          ).merge(@matter_join_params, @matter_category_join_params)}
          it '登録されること' do
            expect do
              post api_v1_client_matters_path(client), params: { matter: @matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1) and change(
              MatterTag, :count).by(1) and change(Task, :count).by(1)
          end
        end
      end
    end
    context '準正常系' do
      context '未ログイン状態の場合' do
        before{
          @matter_params = attributes_for(:matter, matter_category_id: pension_matter_category.id
            ).merge(@contact_opponent_params, @matter_category_join_params)
        }
        it '401エラーが返ってくること' do
          post api_v1_client_matters_path(client), params: { matter: @matter_params }
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
        it '登録されない' do
          expect do
            post api_v1_client_matters_path(client), params: { matter: @matter_params }
          end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
        end
      end
      context 'パラメータが無効な場合' do
        before{
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          @matter_join_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, user_id: session[:user_id], belong_side_id: '個人', office: nil) }}
          @matter_params = attributes_for(:matter, task_template_group_id: task_template_group.id, matter_status_id: ''
            ).merge(@matter_join_params, @contact_opponent_params, @matter_category_join_params)
        }
        it '400エラーが返ってくること' do
          post api_v1_client_matters_path(client), params: { matter: @matter_params }
          expect(response.status).to eq 400
          expect(JSON.parse(response.body)['message']).to eq "登録出来ません。入力必須項目を確認してください"
        end
        it '登録されない' do
          expect do
            post api_v1_client_matters_path(client), params: { matter: @matter_params }
          end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
        end
      end
      context 'client参加がない個人ユーザーでログイン' do
        before{
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          @matter_join_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, user_id: session[:user_id], belong_side_id: '個人', office: nil) }}
          @matter_params = attributes_for(:matter, task_template_group_id: task_template_group.id
            ).merge(@matter_join_params, @contact_opponent_params, @matter_category_join_params)
        }
        it '403エラーが返ってくること' do
          post api_v1_client_matters_path(client), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されない' do
          expect do
            post api_v1_client_matters_path(client), params: { matter: @matter_params }
          end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
        end
      end
      context 'client参加がない事務所userでログイン' do
        before{
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          @matter_join_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, office_id: User.find(session[:user_id]).belonging_office) }}
          @matter_params = attributes_for(:matter, task_template_group_id: task_template_group.id
            ).merge(@matter_join_params, @contact_opponent_params, @matter_category_join_params)
        }
        it '403エラーを返すこと' do
          post api_v1_client_matters_path(client), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されない' do
          expect do
            post api_v1_client_matters_path(client), params: { matter: @matter_params }
          end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count)
        end
      end
    end
  end

  describe 'PUT #update' do
    context '正常系' do
      context 'クライアント管理事務所管理者でログイン' do
        before{
          login_user(client_admin_office_admin, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it 'リクエストが成功すること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 200
        end
        it '更新されること' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to change { Matter.find(matter.id).matter_status_id }.from(matter.matter_status_id).to('終了')
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        before{
          login_user(client_admin_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it 'リクエストが成功すること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 200
        end
        it '更新されること' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to change { Matter.find(matter.id).matter_status_id }.from(matter.matter_status_id).to('終了')
        end
      end
      context '案件管理事務所管理者でログイン' do
        before{
          login_user(matter_admin_office_admin, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it 'リクエストが成功すること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 200
        end
        it '更新されること' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to change { Matter.find(matter.id).matter_status_id }.from(matter.matter_status_id).to('終了')
        end
      end
      context '案件管理個人ユーザーでログイン' do
        before{
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it 'リクエストが成功すること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 200
        end
        it '更新されること' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to change { Matter.find(matter.id).matter_status_id }.from(matter.matter_status_id).to('終了')
        end
      end
      context '案件タグを追加' do
        before{
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, tag_name: 'タグ追加')
        }
        it 'リクエストが成功すること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 200
        end
        it 'タグが登録されること' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to change(MatterTag, :count).by(1)
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        before{
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '401エラーが返ってくること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
        it '更新されないこと' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to_not change { Matter.find(matter.id).matter_status_id }
        end
      end
      context 'パラメータが無効' do
        before{
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: nil)
        }
        it '400エラーが返ってくること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 400
          expect(JSON.parse(response.body)['message']).to eq "更新出来ません。入力必須項目を確認してください"
        end
        it '更新されないこと' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to_not change { Matter.find(matter.id).matter_status_id }
        end
      end
      context 'matter管理権限のない参加ユーザーでログイン' do
        before{
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '403エラーが返ってくること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '更新されないこと' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to_not change { Matter.find(matter.id).matter_status_id }
        end
      end

      context 'client管理権限のない参加ユーザーでログイン' do
        before{
          login_user(client_join_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '403エラーが返ってくること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '更新されないこと' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to_not change { Matter.find(matter.id).matter_status_id }
        end
      end
      context 'matter管理事務所の一般ユーザーでログイン' do
        before{
          login_user(matter_admin_office_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '403エラーが返ってくること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '更新されないこと' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to_not change { Matter.find(matter.id).matter_status_id }
        end
      end
      context 'matter管理事務所の一般ユーザーでログイン' do
        before{
          login_user(client_admin_office_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '403エラーが返ってくること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '更新されないこと' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to_not change { Matter.find(matter.id).matter_status_id }
        end
      end
      context '不参加ユーザーでログイン' do
        before{
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '403エラーが返ってくること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '更新されないこと' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to_not change { Matter.find(matter.id).matter_status_id }
        end
      end
      context '不参加事務所ユーザーでログイン' do
        before{
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '403エラーが返ってくること' do
          put api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '更新されないこと' do
          expect do
            put api_v1_matter_path(matter), params: { matter: @matter_params }
          end.to_not change { Matter.find(matter.id).matter_status_id }
        end
      end
    end
  end
  describe 'PUT #show' do
    context '正常系' do
      # 案件参加ユーザー
      # クライアント参加ユーザー
      # 案件参加事務所ユーザー
      # クライアント参加事務所ユーザー
      context 'クライアント参加事務所ユーザーでログイン' do
        before{
          login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it 'リクエストが成功すること' do
          get api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data']['id']).to eq matter.id
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        before{
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it 'リクエストが成功すること' do
          get api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['data']['id']).to eq matter.id
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        before{
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '401エラーが返ってくること' do
          get api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
          expect(JSON.parse(response.body)['data']).to be nil
        end
      end
      context '不参加ユーザーでログイン' do
        before{
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '403エラーが返ってくること' do
          get api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
          expect(JSON.parse(response.body)['data']).to be nil
        end
      end
      context '不参加事務所ユーザーでログイン' do
        before{
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          @matter_params = attributes_for(:matter, matter_status_id: '終了')
        }
        it '403エラーが返ってくること' do
          get api_v1_matter_path(matter), params: { matter: @matter_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
          expect(JSON.parse(response.body)['data']).to be nil
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context '正常系' do
      context '案件管理ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          delete api_v1_matter_path(matter)
          expect(response.status).to eq 200
        end
        it '更新されること' do
          login_user(matter_admin_user, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_matter_path(matter)
          end.to change { Matter.find(matter.id).archive }.from(true).to(false) and change {
            Matter.find(matter.id).opponents.first.name }.from('テスト姓').to('削除済み')
        end
      end
    end
  end

  describe 'tag_auto_complete' do
    before{
      Tag.destroy_all
      MatterTag.destroy_all
      @tags = create_list(:tag, 5)
      @tags.each_with_index do |tag, i|
        create(:matter_tag, matter_id: matter.id, tag_id: @tags[i].id)
      end
    }
    context '正常系' do
      
      context 'ログイン状態' do
        it 'リクエストが成功すること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          get tag_auto_complete_api_v1_matters_path, params: { term: 'タグ'}
          expect(response).to have_http_status 200
          expect(JSON.parse(response.body)['data']).to eq @tags.map(&:tag_name)
        end
      end
    end
    context '準正常系' do
      context '未ログイン状態' do
        it '401エラーが返ってくること' do
          get tag_auto_complete_api_v1_matters_path, params: { term: '1'}
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['data']).to eq nil
        end
      end
    end
  end
end