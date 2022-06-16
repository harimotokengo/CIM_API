require 'rails_helper'

RSpec.describe 'Offices_requests', type: :request do
  let!(:office) { create(:office) }
  let!(:other_office) { create(:office) }
  let!(:user) { create(:user, office_id: office.id) }
  let!(:other_user) { create(:user, office_id: other_office.id) }
  let!(:belonging_info) { create(:belonging_info, user: user, office: office) }
  let!(:no_belonging_info) { create(:belonging_info, user: user) }
  let!(:other_belonging_info) { create(:belonging_info, user: user, office: other_office) }

  describe 'POST #create' do
    context '正常系' do
      it 'ログイン状態の場合リクエストが成功すること' do
        login_user(user, 'Test-1234', api_v1_login_path)
        office_params = attributes_for(:office)
        post api_v1_offices_path, params: { office: office_params }
        expect(response).to have_http_status 200
      end

      # it 'ログイン状態の場合登録されること' do
      #   login_user(belonging_info.user, 'Test-1234', login_path)
      #   office_params = attributes_for(:office)
      #   expect do
      #     post offices_path, params: { office: office_params }
      #   end.to change(Office, :count).by(1)
      # end
    end
  end
end

