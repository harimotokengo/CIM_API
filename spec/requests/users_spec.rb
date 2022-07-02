require 'rails_helper'

# 一人事務所のuser登録
RSpec.describe 'users', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'POST #create' do
    context '正常系' do
      it 'リクエストが成功すること' do
        user_params = attributes_for(:user)
        post api_v1_users_path, params: { user: user_params }
        expect(response).to have_http_status 200
      end
      it '登録されること' do
        user_params = attributes_for(:user)
        expect do
          post api_v1_users_path, params: { user: user_params }
        end.to change(User, :count).by(1)
      end
    end
    context '準正常系' do
      context 'ログイン状態' do
        it '400エラーが返ってくること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          user_params = attributes_for(:user)
          post api_v1_users_path, params: { user: user_params }
          expect(response).to have_http_status 400
          expect(JSON.parse(response.body)['message']).to eq "Bad Request"
        end
        it '登録されないこと' do
          login_user(user, 'Test-1234', api_v1_login_path)
          user_params = attributes_for(:user)
          expect do
            post api_v1_users_path, params: { user: user_params }
          end.to_not change(User, :count)
        end
      end
      context 'パラメータが無効' do
        it '400エラーが返ってくること' do
          user_params = attributes_for(:user, last_name: '')
          post api_v1_users_path, params: { user: user_params }
          expect(response).to have_http_status 400
          expect(JSON.parse(response.body)['message']).to eq "登録出来ません。入力必須項目を確認してください"
        end
        it '登録されないこと' do
          user_params = attributes_for(:user, last_name: '')
          expect do
            post api_v1_users_path, params: { user: user_params }
          end.to_not change(User, :count)
        end
      end
    end
  end

  describe 'PUT #update' do
    context '正常系' do
      context 'ログイン状態' do
        it 'リクエストが成功すること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          user_params = attributes_for(:user, last_name: '更新テスト')
          put api_v1_user_path(user), params: { user: user_params }
          expect(response.status).to eq 200
        end
        it '更新されること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          user_params = attributes_for(:user, last_name: '更新テスト')
          put api_v1_user_path(user), params: { user: user_params }
          expect(user.reload.last_name).to eq '更新テスト'
        end
      end
      context '画像をアタッチ' do
        it '画像が登録されること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          user_params = attributes_for(:user, avatar: fixture_file_upload('test.jpg'))
          put api_v1_user_path(user), params: { user: user_params }
          expect(user.reload.avatar.filename).to eq 'test.jpg'
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          user_params = attributes_for(:user, last_name: '更新テスト')
          put api_v1_user_path(user), params: { user: user_params }
          expect(response.status).to eq 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
        it '更新されないこと' do
          user_params = attributes_for(:user, last_name: '更新テスト')
          expect do
            put api_v1_user_path(user), params: { user: user_params }
          end.to_not change {User.find(user.id).reload.last_name}
        end
      end
      context '他ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(other_user, 'Test-1234', api_v1_login_path)
          user_params = attributes_for(:user, last_name: '更新テスト')
          put api_v1_user_path(user), params: { user: user_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '更新されないこと' do
          login_user(other_user, 'Test-1234', api_v1_login_path)
          user_params = attributes_for(:user, last_name: '更新テスト')
          expect do
            put api_v1_user_path(user), params: { user: user_params }
          end.to_not change {User.find(user.id).reload.last_name}
        end
      end
      context 'パラメータが無効な場合' do
        it '400エラーが返ってくること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          user_params = attributes_for(:user, last_name: '')
          put api_v1_user_path(user), xhr: true, params: { user: user_params }
          expect(response.status).to eq 400
          expect(JSON.parse(response.body)['message']).to eq "更新出来ません。入力必須項目を確認してください"
        end
        it '更新されないこと' do
          login_user(user, 'Test-1234', api_v1_login_path)
          user_params = attributes_for(:user, last_name: '')
          expect do
            put api_v1_user_path(user), params: { user: user_params }
          end.to_not change {User.find(user.id).reload.last_name}
        end
      end
    end
  end
end
