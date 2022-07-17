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
      context '案件参加事務所ユーザーでログイン' do
        context '自身を登録' do
          it 'リクエストが成功すること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_office_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_office_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to change(MatterAssign, :count).by(1)
          end
        end
        context '案件参加ユーザーを登録' do
          it 'リクエストが成功すること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to change(MatterAssign, :count).by(1)
          end
        end
        context '案件参加事務所ユーザーを登録' do
          it 'リクエストが成功すること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_office_other.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_office_other.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to change(MatterAssign, :count).by(1)
          end
        end
        context 'クライアント参加ユーザーを登録' do
          it 'リクエストが成功すること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: client_join_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: client_join_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to change(MatterAssign, :count).by(1)
          end
        end
        context 'クライアント参加事務所ユーザーで登録' do
          it 'リクエストが成功すること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: client_join_office_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: client_join_office_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to change(MatterAssign, :count).by(1)
          end
        end
      end
      context '案件参加ユーザーでログイン' do
        context '自身を登録' do
          it 'リクエストが成功すること' do
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to change(MatterAssign, :count).by(1)
          end
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '自身を登録' do
          it 'リクエストが成功すること' do
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: client_join_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: client_join_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to change(MatterAssign, :count).by(1)
          end
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '自身を登録' do
          it 'リクエストが成功すること' do
            login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: client_join_office_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: client_join_office_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to change(MatterAssign, :count).by(1)
          end
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_user.id)
          post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
        it '登録されないこと' do
          matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_user.id)
          expect do
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
          end.to_not change(MatterAssign, :count)
        end
      end
      context '案件参加ユーザーでログイン' do
        context '案件不参加ユーザーを登録' do
          it '400エラーが返ってくること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: injoin_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 400
            expect(JSON.parse(response.body)['message']).to eq "Bad Request"
          end
          it '登録されないこと' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: injoin_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to_not change(MatterAssign, :count)
          end
        end
        context '案件不参加事務所ユーザーを登録' do
          it '400エラーが返ってくること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: injoin_office_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 400
            expect(JSON.parse(response.body)['message']).to eq "Bad Request"
          end
          it '登録されないこと' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: injoin_office_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to_not change(MatterAssign, :count)
          end
        end
        context '登録済みユーザーを登録' do
          before{
            @assigned_user = create(:user) 
            assigned_user_belonging_info = create(:belonging_info, user: @assigned_user, office: matter_join_office)
            matter_assign = create(:matter_assign, matter: matter, user: @assigned_user)
          }
          it '400エラーが返ってくること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: @assigned_user.id)
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            expect(response).to have_http_status 400
            expect(JSON.parse(response.body)['message']).to eq "Bad Request"
          end
          it '登録されないこと' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign_params = attributes_for(:matter_assign, user_id: @assigned_user.id)
            expect do
              post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
            end.to_not change(MatterAssign, :count)
          end
        end
      end
      context '不参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_office_user.id)
          post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されないこと' do
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_office_user.id)
          expect do
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
          end.to_not change(MatterAssign, :count)
        end
      end
      context '不参加事務所ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_office_user.id)
          post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '登録されないこと' do
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          matter_assign_params = attributes_for(:matter_assign, user_id: matter_join_office_user.id)
          expect do
            post api_v1_matter_matter_assigns_path(matter), params: { matter_assign: matter_assign_params }
          end.to_not change(MatterAssign, :count)
        end
      end
    end
  end

  describe 'POST #destroy' do
    context '正常系' do
      context '案件参加事務所ユーザーでログイン' do
        context '自身を削除' do
          it 'リクエストが成功すること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to change(MatterAssign, :count).by(-1)
          end
        end
        context '案件参加事務所ユーザーを削除' do
          it 'リクエストが成功すること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_office_other)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_office_other)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to change(MatterAssign, :count).by(-1)
          end
        end
        context '案件参加ユーザーを削除' do
          it 'リクエストが成功すること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to change(MatterAssign, :count).by(-1)
          end
        end
        context 'クライアント参加事務所ユーザーを削除' do
          it 'リクエストが成功すること' do
            matter_assign = create(:matter_assign, matter: matter, user: client_join_office_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            matter_assign = create(:matter_assign, matter: matter, user: client_join_office_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to change(MatterAssign, :count).by(-1)
          end
        end
        context 'クライアント参加ユーザーを削除' do
          it 'リクエストが成功すること' do
            matter_assign = create(:matter_assign, matter: matter, user: client_join_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            matter_assign = create(:matter_assign, matter: matter, user: client_join_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to change(MatterAssign, :count).by(-1)
          end
        end
      end
      context '案件参加ユーザーでログイン' do
        context '自身を削除' do
          it 'リクエストが成功すること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            login_user(matter_join_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to change(MatterAssign, :count).by(-1)
          end
        end
      end
      context 'クライアント参加事務所ユーザーでログイン' do
        context '自身を削除' do
          it 'リクエストが成功すること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to change(MatterAssign, :count).by(-1)
          end
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        context '自身を削除' do
          it 'リクエストが成功すること' do
            matter_assign = create(:matter_assign, matter: matter, user: client_join_user)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            matter_assign = create(:matter_assign, matter: matter, user: client_join_user)
            login_user(client_join_user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to change(MatterAssign, :count).by(-1)
          end
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
          delete api_v1_matter_matter_assign_path(matter, matter_assign)
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
        it '削除されないこと' do
          matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
          expect do
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
          end.to_not change(MatterAssign, :count)
        end
      end
      context '案件参加ユーザーでログイン' do
        context '案件不参加ユーザーを削除' do
          it '400エラーが返ってくること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign = create(:matter_assign, matter: matter, user: injoin_user)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 400
            expect(JSON.parse(response.body)['message']).to eq "Bad Request"
          end
          it '削除されないこと' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign = create(:matter_assign, matter: matter, user: injoin_user)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to_not change(MatterAssign, :count)
          end
        end
        context '案件不参加事務所ユーザーを削除' do
          it '400エラーが返ってくること' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign = create(:matter_assign, matter: matter, user: injoin_office_user)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 400
            expect(JSON.parse(response.body)['message']).to eq "Bad Request"
          end
          it '削除されないこと' do
            login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
            matter_assign = create(:matter_assign, matter: matter, user: injoin_office_user)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to_not change(MatterAssign, :count)
          end
        end
      end
      context '不参加ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
          it '403エラーが返ってくること' do
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 403
            expect(JSON.parse(response.body)['message']).to eq "Forbidden"
          end
          it '削除されないこと' do
            login_user(injoin_user, 'Test-1234', api_v1_login_path)
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to_not change(MatterAssign, :count)
          end
        end
      end
      context '不参加事務所ユーザーでログイン' do
        context '案件参加ユーザーを削除' do
          it '403エラーが返ってくること' do
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            delete api_v1_matter_matter_assign_path(matter, matter_assign)
            expect(response).to have_http_status 403
            expect(JSON.parse(response.body)['message']).to eq "Forbidden"
          end
          it '削除されないこと' do
            login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
            matter_assign = create(:matter_assign, matter: matter, user: matter_join_user)
            expect do
              delete api_v1_matter_matter_assign_path(matter, matter_assign)
            end.to_not change(MatterAssign, :count)
          end
        end
      end
    end
  end
end
