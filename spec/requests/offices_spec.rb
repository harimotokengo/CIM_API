require 'rails_helper'

RSpec.describe 'Offices_requests', type: :request do
  let!(:office) { create(:office) }
  let!(:other_office) { create(:office) }
  let!(:user) { create(:user) }
  
  let!(:belonging_user) { create(:user) }
  let!(:admin_user) { create(:user) }
  let!(:admin_other_user) { create(:user) }
  let!(:belonging_info) { create(:belonging_info, user: belonging_user, office: office) }
  let!(:other_belonging_info) { create(:belonging_info, user: admin_other_user, office: other_office, admin: true) }
  let!(:admin_belonging_info) { create(:belonging_info, user: admin_user, office: office, admin: true) }

  describe 'POST #create' do
    context '正常系' do
      it 'ログイン状態の場合リクエストが成功すること' do
        login_user(user, 'Test-1234', api_v1_login_path)
        office_params = attributes_for(:office)
        post api_v1_offices_path, params: { office: office_params }
        expect(response).to have_http_status 200
      end

      it 'ログイン状態の場合登録されること' do
        login_user(user, 'Test-1234', api_v1_login_path)
        office_params = attributes_for(:office)
        expect do
          post api_v1_offices_path, params: { office: office_params }
        end.to change(Office, :count).by(1)
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          office_params = attributes_for(:office)
          post api_v1_offices_path, params: { office: office_params }
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end

        it '登録されないこと' do
          office_params = attributes_for(:office)
          expect do
            post api_v1_offices_path, params: { office: office_params }
          end.to_not change(Office, :count)
        end
      end
      context 'パラメータが無効' do
        it '400エラーが返ってくること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, name: '')
          post api_v1_offices_path, params: { office: office_params }
          expect(response).to have_http_status 400
          expect(JSON.parse(response.body)['message']).to eq "登録出来ません。入力必須項目を確認してください"
        end

        it '登録されない' do
          login_user(user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, name: '')
          expect do
            post api_v1_offices_path, params: { office: office_params }
          end.to_not change(Office, :count)
        end
      end
      context '事務所を作成済の場合' do
        it '409エラーが返ってくること' do
          login_user(belonging_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office)
          post api_v1_offices_path, params: { office: office_params }
          expect(response).to have_http_status 409
          expect(JSON.parse(response.body)['message']).to eq "すでに所属済みです"
        end
        it '登録されない' do
          login_user(belonging_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office)
          expect do
            post api_v1_offices_path, params: { office: office_params }
          end.to_not change(Office, :count)
        end
      end
    end
  end

  describe 'PUT #update' do
    context '正常系' do
      context '管理ユーザーでログイン' do
        it 'ログイン状態の場合リクエストが成功すること' do
          login_user(admin_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, name: '更新テスト')
          put api_v1_office_path(office), params: { office: office_params }
          expect(response.status).to eq 200
        end
  
        it 'ログイン状態の場合更新されること' do
          login_user(admin_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, name: '更新テスト')
          expect do
            put api_v1_office_path(office), params: { office: office_params }
          end.to change { belonging_info.office.reload.name }.from('テスト事務所').to('更新テスト')
        end
      end
    end

    context '準正常系' do
      context '未ログイン状態' do
        it '401エラーが返ってくること' do
          office_params = attributes_for(:office, prefecture: '埼玉県')
          put api_v1_office_path(office), params: { office: office_params }
          expect(response.status).to eq 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
  
        it '更新されないこと' do
          office_params = attributes_for(:office, prefecture: '埼玉県')
          expect do
            put api_v1_office_path(office), params: { office: office_params }
          end.to_not change { belonging_info.office.reload.prefecture }.from('東京都')
        end
      end
      context 'パラメータが無効' do
        it 'パラメータが無効な場合リクエストが成功すること' do
          login_user(admin_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, prefecture: '090')
          put api_v1_office_path(office), params: { office: office_params }
          expect(response.status).to eq 400
        end
  
        it 'パラメータが無効な場合更新されないこと' do
          login_user(admin_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, phone_number: '090')
          expect do
            put api_v1_office_path(office), params: { office: office_params }
          end.to_not change(Office.find(office.id), :phone_number)
        end
      end
      context '他事務所管理ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(admin_other_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, name: '更新テスト')
          put api_v1_office_path(office), params: { office: office_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '更新されないこと' do
          login_user(admin_other_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, name: '更新テスト')
          expect do
            put api_v1_office_path(office), params: { office: office_params }
          end.to_not change(Office.find(office.id).reload, :name)
        end
      end
      context '管理権限のないユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(belonging_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, name: '更新テスト')
          put api_v1_office_path(office), params: { office: office_params }
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
        it '更新されないこと' do
          login_user(belonging_user, 'Test-1234', api_v1_login_path)
          office_params = attributes_for(:office, name: '更新テスト')
          expect do
            put api_v1_office_path(office), params: { office: office_params }
          end.to_not change(Office.find(office.id).reload, :name)
        end
      end
    end
  end
end

