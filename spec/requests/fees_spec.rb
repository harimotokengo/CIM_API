require 'rails_helper'

RSpec.describe 'fees_requests', type: :request do

  describe 'POST #create' do
    context '正常系' do
      it 'ログイン状態の場合、リクエストが成功すること(matter)' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to matter_fees_matter_path(matter)
      end
      it 'ログイン状態の場合、登録されること(matter)' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'ログイン状態の場合、編集ログが登録されること(matter)' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
      it 'ログイン状態の場合、リクエストが成功すること(project)' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to project_inquiry_path(project, inquiry)
      end
      it 'ログイン状態の場合、登録されること(project)' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'ログイン状態の場合、編集ログが登録されること(project)' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
      it 'matterへの参加(matter_join管理者、事務所参加)がある同事務所userの場合、リクエストが成功すること' do
        login_user(belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to matter_fees_matter_path(matter)
      end
      it 'matterへの参加(matter_join管理者、事務所参加)がある同事務所userの場合、登録できること' do
        login_user(belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'matterへの参加(matter_join管理者、事務所参加)がある同事務所userの場合、編集ログが登録できること' do
        login_user(belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
      it 'projectへの参加(project_assign管理者、事務所参加)がある同事務所userの場合、リクエストが成功すること' do
        login_user(belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to project_inquiry_path(project, inquiry)
      end
      it 'projectへの参加(project_assign管理者、事務所参加)がある同事務所userの場合、登録できること' do
        login_user(belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'projectへの参加(project_assign管理者、事務所参加)がある同事務所userの場合、編集ログを登録できること' do
        login_user(belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
      it 'matterへの参加(matter_join管理者、個人参加)がある他事務所userの場合、リクエストが成功すること' do
        login_user(other_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to matter_fees_matter_path(matter)
      end
      it 'matterへの参加(matter_join管理者、個人参加)がある他事務所userの場合、登録されること' do
        login_user(other_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'matterへの参加(matter_join管理者、個人参加)がある他事務所userの場合、編集ログが登録されること' do
        login_user(other_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
      it 'projectへの参加(project_assign管理者、個人参加)がある他事務所userの場合、リクエストが成功すること' do
        login_user(other_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to project_inquiry_path(project, inquiry)
      end
      it 'projectへの参加(project_assign管理者、個人参加)がある他事務所userの場合、登録されること' do
        login_user(other_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'projectへの参加(project_assign管理者、個人参加)がある他事務所userの場合、編集ログが登録されること' do
        login_user(other_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
      it 'matterへの参加(matter_join管理者でない、事務所参加)がある同事務所userの場合、リクエストが成功すること' do
        login_user(other2_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to matter_fees_matter_path(matter)
      end
      it 'matterへの参加(matter_join管理者でない、事務所参加)がある同事務所userの場合、登録されること' do
        login_user(other2_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'matterへの参加(matter_join管理者でない、事務所参加)がある同事務所userの場合、編集ログが登録されること' do
        login_user(other2_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
      it 'projectへの参加(project_assign管理者でない、事務所参加)がある同事務所userの場合、リクエストが成功すること' do
        login_user(other2_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to project_inquiry_path(project, inquiry)
      end
      it 'projectへの参加(project_assign管理者でない、事務所参加)がある同事務所userの場合、登録されること' do
        login_user(other2_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'projectへの参加(project_assign管理者でない、事務所参加)がある同事務所userの場合、編集ログが登録されること' do
        login_user(other2_belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
      it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所userの場合、リクエストが成功すること' do
        login_user(other_belonging_info3.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to matter_fees_matter_path(matter)
      end
      it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所userの場合、登録されること' do
        login_user(other_belonging_info3.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所userの場合、編集ログが登録されること' do
        login_user(other_belonging_info3.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
      it 'projectへの参加(project_assign管理者でない、個人参加)がある他事務所userの場合、リクエストが成功すること' do
        login_user(other_belonging_info3.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to project_inquiry_path(project, inquiry)
      end
      it 'projectへの参加(project_assign管理者でない、個人参加)がある他事務所userの場合、登録されること' do
        login_user(other_belonging_info3.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(Fee, :count).by(1)
      end
      it 'projectへの参加(project_assign管理者でない、個人参加)がある他事務所userの場合、編集ログが登録されること' do
        login_user(other_belonging_info3.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to change(EditLog, :count).by(1)
      end
    end
    context '準正常系' do
      it '未ログイン状態の場合、ログイン画面にリダイレクトされること' do
        fee_params = attributes_for(:fee, matter_id: matter.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path
      end
      it '未ログイン状態の場合、登録されない' do
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to_not change(Fee, :count)
      end
      it 'パラメーターが無効な場合、リクエストが成功すること' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id, price: '')
        post fees_path, xhr: true, params: { fee: fee_params }
        expect(response).to have_http_status 200
      end
      it 'パラメーターが無効な場合、登録されない' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id, price: '')
        expect do
          post fees_path, xhr: true, params: { fee: fee_params }
        end.to_not change(Fee, :count)
      end
      xit 'officeの登録がない場合、〇〇にリダイレクトされること' do
        # login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        post fees_path, params: { fee: fee_params }
        expect(response.status).to eq 302
        # expect(response).to redirect_to login_path
      end
      xit 'officeの登録がない場合、更新されない' do
        # login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id, price: '')
        expect do
          post fees_path, params: { fee: fee_params }
        end.to_not change(Fee, :count)
      end
      it 'matterへの参加がない場合、トップページにリダイレクトされること' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: other_matter.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
      it 'matterへの参加がない場合、登録されない' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: other_matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to_not change(Fee, :count)
      end
      it 'projectへの参加がない場合、トップページにリダイレクトされること' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: other_inquiry.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
      it 'projectへの参加がない場合、登録されない' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: other_inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to_not change(Fee, :count)
      end
      it 'matterへの参加がない他事務所userの場合、トップページにリダイレクトされること' do
        login_user(other_belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
      it 'matterへの参加がない他事務所userの場合、登録されない' do
        login_user(other_belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, matter_id: matter.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to_not change(Fee, :count)
      end
      it 'projectへの参加がない他事務所userの場合、トップページにリダイレクトされること' do
        login_user(other_belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        post fees_path, params: { fee: fee_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
      it 'projectへの参加がない他事務所userの場合、登録されない' do
        login_user(other_belonging_info2.user, 'Test-1234', login_path)
        fee_params = attributes_for(:fee, inquiry_id: inquiry.id)
        expect do
          post fees_path, params: { fee: fee_params }
        end.to_not change(Fee, :count)
      end
    end
  end
end