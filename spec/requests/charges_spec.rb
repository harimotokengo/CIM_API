require 'rails_helper'

# 案件のピン止め
RSpec.describe 'charges_requests', type: :request do
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
          post api_v1_matter_charges_path(matter)
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(matter_join_user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_matter_charges_path(matter)
          end.to change(Charge, :count).by(1)
        end
      end
      context '案件参加事務所ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          post api_v1_matter_charges_path(matter)
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_matter_charges_path(matter)
          end.to change(Charge, :count).by(1)
        end
      end
      context 'クライアント参加ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(client_join_user, 'Test-1234', api_v1_login_path)
          post api_v1_matter_charges_path(matter)
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(client_join_user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_matter_charges_path(matter)
          end.to change(Charge, :count).by(1)
        end
      end
      context 'クライアント事務所参加ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
          post api_v1_matter_charges_path(matter)
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(client_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_matter_charges_path(matter)
          end.to change(Charge, :count).by(1)
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          post api_v1_matter_charges_path(matter)
          expect(response).to have_http_status 401
        end
        it '登録されないこと' do
          expect do
            post api_v1_matter_charges_path(matter)
          end.to_not change(Charge, :count)
        end
      end
      context '不参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          post api_v1_matter_charges_path(matter)
          expect(response).to have_http_status 403
        end
        it '登録されないこと' do
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_matter_charges_path(matter)
          end.to_not change(Charge, :count)
        end
      end
      context '不参加事務所ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          post api_v1_matter_charges_path(matter)
          expect(response).to have_http_status 403
        end
        it '登録されないこと' do
          login_user(injoin_office_user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_matter_charges_path(matter)
          end.to_not change(Charge, :count)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context '正常系' do
      context 'ピン止めしたユーザーでログイン' do
        context '案件参加ユーザーでログイン' do
          it 'リクエストが成功すること' do
            charge = create(:charge, user: matter_join_user, matter: matter)
            login_user(charge.user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_charge_path(matter, charge)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            charge = create(:charge, user: matter_join_user, matter: matter)
            login_user(charge.user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_charge_path(matter, charge)
            end.to change(Charge, :count).by(-1)
          end
        end
        context '案件参加事務所ユーザーでログイン' do
          it 'リクエストが成功すること' do
            charge = create(:charge, user: matter_join_office_user, matter: matter)
            login_user(charge.user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_charge_path(matter, charge)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            charge = create(:charge, user: matter_join_office_user, matter: matter)
            login_user(charge.user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_charge_path(matter, charge)
            end.to change(Charge, :count).by(-1)
          end
        end
        context 'クライアント参加ユーザーでログイン' do
          it 'リクエストが成功すること' do
            charge = create(:charge, user: client_join_user, matter: matter)
            login_user(charge.user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_charge_path(matter, charge)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            charge = create(:charge, user: client_join_user, matter: matter)
            login_user(charge.user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_charge_path(matter, charge)
            end.to change(Charge, :count).by(-1)
          end
        end
        context 'クライアント事務所参加ユーザーでログイン' do
          it 'リクエストが成功すること' do
            charge = create(:charge, user: client_join_office_user, matter: matter)
            login_user(charge.user, 'Test-1234', api_v1_login_path)
            delete api_v1_matter_charge_path(matter, charge)
            expect(response).to have_http_status 200
          end
          it '削除されること' do
            charge = create(:charge, user: client_join_office_user, matter: matter)
            login_user(charge.user, 'Test-1234', api_v1_login_path)
            expect do
              delete api_v1_matter_charge_path(matter, charge)
            end.to change(Charge, :count).by(-1)
          end
        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          charge = create(:charge, user: client_join_user, matter: matter)
          delete api_v1_matter_charge_path(matter, charge)
          expect(response).to have_http_status 401
        end
        it '削除されること' do
          charge = create(:charge, user: client_join_user, matter: matter)
          expect do
            delete api_v1_matter_charge_path(matter, charge)
          end.to_not change(Charge, :count)
        end
      end
      context '不参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          charge = create(:charge, user: injoin_user, matter: matter)
          login_user(charge.user, 'Test-1234', api_v1_login_path)
          delete api_v1_matter_charge_path(matter, charge)
          expect(response).to have_http_status 403
        end
        it '削除されないこと' do
          charge = create(:charge, user: injoin_user, matter: matter)
          login_user(charge.user, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_matter_charge_path(matter, charge)
          end.to_not change(Charge, :count)
        end
      end
      context '不参加事務所ユーザーでログイン' do
        it '403エラーが返ってくること' do
          charge = create(:charge, user: injoin_office_user, matter: matter)
          login_user(charge.user, 'Test-1234', api_v1_login_path)
          delete api_v1_matter_charge_path(matter, charge)
          expect(response).to have_http_status 403
        end
        it '削除されないこと' do
          charge = create(:charge, user: injoin_office_user, matter: matter)
          login_user(charge.user, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_matter_charge_path(matter, charge)
          end.to_not change(Charge, :count)
        end
      end
      context 'ピン止めしていないユーザーでログイン' do
        it '403エラーが返ってくること' do
          charge = create(:charge, user: matter_join_user, matter: matter)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          delete api_v1_matter_charge_path(matter, charge)
          expect(response).to have_http_status 403
        end
        it '削除されないこと' do
          charge = create(:charge, user: matter_join_user, matter: matter)
          login_user(matter_join_office_user, 'Test-1234', api_v1_login_path)
          expect do
            delete api_v1_matter_charge_path(matter, charge)
          end.to_not change(Charge, :count)
        end
      end
    end
  end
end