require 'rails_helper'

# 事務所招待
RSpec.describe 'user_invites', type: :request do
  let!(:office) { create(:office) }
  let!(:other_office) { create(:office) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin_user) { create(:user) }
  let!(:other_admin_user) { create(:user) }
  let!(:user_invite) { create(:user_invite, sender: admin_user) }
  let!(:belonging_info) { create(:belonging_info, user: user, office: office) }
  let!(:other_belonging_info) { create(:belonging_info, user: other_user, office: other_office) }
  let!(:admin_belonging_info) { create(:belonging_info, user: admin_user, office: office, admin: true) }
  let!(:other_admin_belonging_info) { create(:belonging_info, user: other_admin_user, office: other_office, admin: true) }

  describe 'GET #new' do
    context '正常系' do
      context '管理ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(admin_belonging_info.user, 'Test-1234', login_path)
          get new_user_invite_path, xhr: true
          expect(response).to have_http_status 200
        end
      end
      context 'create後' do
        xit '招待URLが発行されること' do

        end
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do
          get new_user_invite_path
          expect(response.status).to eq 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
      end
      context '一般ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          get new_user_invite_path
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
      end
    end
  end

  describe 'POST #create' do
    context '正常系' do
      context '管理ユーザーでログイン' do
        it 'リクエストが成功すること' do
          login_user(admin_belonging_info.user, 'Test-1234', login_path)
          get make_invite_url_user_invites_path
          expect(response).to have_http_status 302
          expect(response).to redirect_to new_user_invite_path(user_invite: UserInvite.first)
        end
        it '登録されること' do
          login_user(admin_user, 'Test-1234', login_path)
          expect do
            post api_v1_user_invies_path, params: { user: user_params }
          end.to_not change(User, :count)
        end

    end
    context '準正常系' do
      it '未ログインの場合、ログイン画面にリダイレクトされること' do
        get make_invite_url_user_invites_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to login_path
      end
      it '一般ユーザーでログインの場合、ルートにリダイレクトされること' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        get make_invite_url_user_invites_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #show' do
    context '正常系' do
      it '招待URLが有効な場合、リクエストが成功すること' do
        get user_invite_path(user_invite.id, tk: user_invite.token)
        expect(response).to have_http_status 200
      end
    end
    context '準正常系' do
      it '招待URLが無効な場合、ルートにリダイレクトすること' do
        get user_invite_path(user_invite.id, tk: 'NG_token')
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #join' do
    context '正常系' do
      it '他事務所ユーザーでログインの場合、ルートにリダイレクトされること' do
        login_user(other_belonging_info.user, 'Test-1234', login_path)
        post user_invites_path(user_invite_id: user_invite.id)
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
      it '他事務所ユーザーでログインの場合、移籍処理されること' do
        login_user(other_belonging_info.user, 'Test-1234', login_path)
        expect do
          post user_invites_path(user_invite_id: user_invite.id)
        end.to change(BelongingInfo.where(user_id: other_belonging_info.user.id), :count).by(1) and
          change(BelongingInfo.where(user_id: other_belonging_info.user.id, office: other_office), :join).from('所属').to('退所') and
          change(UserInvite.find(user_invite.id), :join).from(false).to(true)
      end
    end
    context '準正常系' do
      it '未ログインの場合、ログインして招待画面にリダイレクトされること' do
        post user_invites_path(user_invite_id: user_invite.id)
        expect(response).to have_http_status 302
        expect(response).to redirect_to new_session_user_invites_path(user_invite_id: user_invite.id)
      end
      it '未ログインの場合、移籍処理されないこと' do
        expect do
          post user_invites_path(user_invite_id: user_invite.id)
        end.to_not change(BelongingInfo.where(user_id: other_belonging_info.user.id), :count)
      end
      it '自事務所ユーザーでログインの場合、ルートにリダイレクトされること' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        post user_invites_path(user_invite_id: user_invite.id)
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
      it '自事務所ユーザーでログインの場合、移籍処理されないこと' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        expect do
          post user_invites_path(user_invite_id: user_invite.id)
        end.to_not change(BelongingInfo.where(user_id: other_belonging_info.user.id), :count)
      end
      it '他事務所管理ユーザーでログインの場合、ルートにリダイレクトされること' do
        login_user(other_admin_belonging_info.user, 'Test-1234', login_path)
        post user_invites_path(user_invite_id: user_invite.id)
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
      it '他事務所管理ユーザーでログインの場合、移籍処理されないこと' do
        login_user(other_admin_belonging_info.user, 'Test-1234', login_path)
        expect do
          post user_invites_path(user_invite_id: user_invite.id)
        end.to_not change(BelongingInfo.where(user_id: other_belonging_info.user.id), :count)
      end
      # 招待URLが期限切れ
    end
  end

  describe 'POST #reg_and_join' do
    context '正常系' do
      it '未ログイン状態の場合ルートにリダイレクトされること' do
        user_params = attributes_for(:invite_user_form, office_id: office.id)
        post create_and_user_reg_user_invites_path(user_invite_id: user_invite.id),
             params: { invite_user_form: user_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
      it '未ログイン状態の場合、招待者の事務所にユーザー登録されること' do
        user_params = attributes_for(:invite_user_form, office_id: office.id)
        expect do
          post create_and_user_reg_user_invites_path(user_invite_id: user_invite.id),
               params: { invite_user_form: user_params }
        end.to change(BelongingInfo.where(office_id: office.id), :count).by(1) and
          change(UserInvite.find(user_invite.id), :join).from(false).to(true)
      end
    end
    context '準正常系' do
      it 'ログイン状態の場合,、ルートにリダイレクトされること' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        user_params = attributes_for(:invite_user_form, office_id: office.id)
        post create_and_user_reg_user_invites_path(user_invite_id: user_invite.id),
             params: { invite_user_form: user_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
      it 'ログイン状態の場合、招待者の事務所にユーザー登録されないこと' do
        login_user(belonging_info.user, 'Test-1234', login_path)
        user_params = attributes_for(:invite_user_form, office_id: office.id)
        expect do
          post create_and_user_reg_user_invites_path(user_invite_id: user_invite.id),
               params: { invite_user_form: user_params }
        end.to_not change(BelongingInfo.where(office_id: office.id), :count)
      end
    end
  end
end
