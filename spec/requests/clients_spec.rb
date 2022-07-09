require 'rails_helper'

RSpec.describe "Clients", type: :request do
  let!(:office) { create(:office) }
  let!(:other_office) { create(:office) }
  let!(:other2_office) { create(:office) }
  let!(:user) { create(:user, office_id: office.id) }
  let!(:user2) { create(:user, office_id: office.id) }
  let!(:user3) { create(:user, office_id: office.id) }
  let!(:other_user) { create(:user, office_id: other_office.id) }
  let!(:other_user2) { create(:user, office_id: other_office.id) }
  let!(:other_user3) { create(:user, office_id: other_office.id) }
  let!(:other_user4) { create(:user, office_id: other_office.id) }
  let!(:other_user5) { create(:user, office_id: other_office.id) }
  let!(:other2_user) { create(:user, office_id: other2_office.id) }
  let!(:injoin_user) { create(:user) }

  let!(:matter_category) { create(:matter_category) }

  let!(:client) { create(:client) }
  let!(:other_client) { create(:client) }
  let!(:matter) { create(:matter, client: client, user: user, matter_category_id: matter_category.id) }
  let!(:other_matter) { create(:matter, client: other_client, user: other_user) }
  let!(:matter_join_office) { create(:matter_join, matter: matter, office: office, belong_side_id: 1) }
  let!(:matter_join_other_user) { create(:matter_join, matter: matter, user: other_user, belong_side_id: 2) }
  let!(:matter_join_other_user3) { create(:matter_join, matter: matter, user: other_user3, belong_side_id: 2, admin: false) }
  let!(:matter_join_other_user4) { create(:matter_join, matter: matter, user: other_user4, belong_side_id: 2) }
  let!(:matter_join_other_user5) { create(:matter_join, matter: matter, user: other_user5, belong_side_id: 2, admin: false) }
  let!(:matter_join_other2_office) { create(:matter_join, matter: matter, office: other2_office, belong_side_id: 1, admin: false) }
  let!(:other_matter_join_office) { create(:matter_join, matter: other_matter, office: other_office, belong_side_id: 1) }

  let!(:client_join_office) { create(:client_join, client: client, office: office, belong_side_id: 1) }
  let!(:client_join_other_user) { create(:client_join, client: client, user: other_user, belong_side_id: 2) }

  let!(:client_contact_phone_number) { create(:contact_phone_number, client: client) }
  let!(:client_contact_email) { create(:contact_email, client: client) }
  let!(:client_contact_address) { create(:contact_address, client: client) }

  let!(:belonging_info) { create(:belonging_info, user: user, office: office, admin: true) }
  let!(:belonging_info2) { create(:belonging_info, user: user2, office: office) }
  let!(:belonging_info3) { create(:belonging_info, user: user3, office: office, admin: true) }
  let!(:other_belonging_info) { create(:belonging_info, user: other_user, office: other_office, admin: true) }
  let!(:other_belonging_info2) { create(:belonging_info, user: other_user2, office: other_office) }
  let!(:other_belonging_info3) { create(:belonging_info, user: other_user3, office: other_office, admin: true) }
  let!(:other_belonging_info4) { create(:belonging_info, user: other_user4, office: other_office) }
  let!(:other_belonging_info5) { create(:belonging_info, user: other_user5, office: other_office) }
  let!(:other2_belonging_info) { create(:belonging_info, user: other2_user, office: other2_office, admin: true) }
  
  # 検索params
    # full_name
    # first_name
    # last_name
    # matter_category_name client_full_name

    # 存在しないclient_name
    # client_name 存在しないmatter_category_name

  # describe "GET #index" do
  #   context '正常系' do
  #     context '参加事務所ユーザーでログイン' do
  #       it 'リクエストが成功すること' do

  #       end
  #     end

  #     context '参加ユーザーでログイン' do
  #       it 'リクエストが成功すること' do

  #       end
  #     end
  #   end

  #   context '準正常系' do
  #     context '未ログイン' do
  #       it '401エラーが返ってくること' do

  #       end
  #     end
  #     context '不参加ユーザーでログイン' do
  #       it '403エラーが返ってくること' do
  #       end
  #     end
  #   end
  # end

  # 登録者または登録者の事務所がclient_joinのadminに登録されること
  # 事務所なしユーザーは組織で登録できない
  describe 'POST #create' do
    before do
      contact_phone_number_params = {contact_phone_numbers_attributes: { "0": attributes_for(:contact_phone_number)}}
      invalid_contact_phone_number_params = { contact_phone_numbers_attributes: {"0": attributes_for(:contact_phone_number, phone_number: '123456') }}
      contact_email_params = { contact_emails_attributes: { "0": attributes_for(:contact_email) }  }
      contact_address_params = { contact_addresss_attributes: {  "0": attributes_for(:contact_address)}}
      opponent_params = {opponents_attributes: { "0": attributes_for(:opponent)}}
      contact_opponent_params = {opponents_attributes: { "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params) }}
      matter_join_params = { matter_joins_attributes: { "0": attributes_for(:matter_join) }}
      client_join_params = { client_joins_attributes: { "0": attributes_for(:client_join) }}
      matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(opponent_params, matter_join_params) } }
      min_matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(matter_join_params) }}
      contact_matter_params = {matters_attributes: { "0": attributes_for(:matter, user_id: user.id).merge(contact_opponent_params, matter_join_params)}}
      @client_params = attributes_for(:client).merge(matter_params, client_join_params)
      @min_client_params =  attributes_for(:client).merge(min_matter_params, client_join_params)
      @contact_client_params = attributes_for(:client).merge(contact_phone_number_params, contact_email_params, contact_address_params, matter_params, client_join_params)
      @contact_opponent_client_params = attributes_for(:client).merge(contact_matter_params, client_join_params)
      @invalid_client_params = attributes_for(:client, name: '').merge(matter_params, client_join_params)
      @invalid_contact_client_params = attributes_for(:client).merge(invalid_contact_phone_number_params, matter_params, client_join_params)
    end
    context '正常系' do
      context '参加事務所ユーザーでログイン、クライアント、案件、相手方等を入力' do
        
        it 'リクエストが成功すること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          post api_v1_clients_path, params: { client: @client_params}
          expect(response).to have_http_status 200
        end

        it '登録されること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_clients_path, params: { client: @client_params }
          end.to change(Client, :count).by(1) and change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(MatterJoin, :count).by(1)
        end
      end

      context '参加事務所ユーザーでログイン、クライアント、案件を入力' do
        it 'リクエストが成功すること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          post api_v1_clients_path, params: { client: @min_client_params }
          expect(response).to have_http_status 200
        end
        it '登録されること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_clients_path, params: { client: @min_client_params }
          end.to change(Client, :count).by(1) and change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
        end
      end
      context '参加事務所ユーザーでログイン、クライアント、案件、クライアント連絡先を入力' do
        it 'クライアント連絡先が同時に登録されること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_clients_path, params: { client: @contact_client_params }
          end.to change(Client, :count).by(1).and change(ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1)
        end
      end
      context '参加事務所ユーザーでログイン、クライアント、案件、相手方、相手方連絡先を入力' do
        it '相手方の連絡先が同時に登録されること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_clients_path, params: { client: @contact_client_params }
          end.to change(Client, :count).by(1) and change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1)
        end
      end
      # it '編集ログが登録されること' do
      #   login_user(belonging_info.user, 'Test-1234', login_path)
      #   matter_join_params = {
      #     matter_joins_attributes: {
      #       "0": attributes_for(:matter_join)
      #     }
      #   }
      #   matter_params = {
      #     matters_attributes: {
      #       "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
      #     }
      #   }
      #   client_params = attributes_for(:client).merge(matter_params)
      #   expect do
      #     post clients_path, params: { client: client_params, tab_btn: 1 }
      #   end.to change(Client, :count).by(1) and change(Matter, :count).by(1) and change(MatterJoin, :count).by(1) and change(EditLog, :count).by(1)
      # end
    end
    context '準正常系' do
      context '未ログイン状態' do
        it '401エラーが返ってくること' do
          post api_v1_clients_path, params: { client: @client_params }
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
        it '登録されない' do
          expect do
            post api_v1_clients_path, params: { client: @client_params }
          end.to_not change(Client, :count) and change(Matter, :count) and change(MatterJoin, :count)
        end
      end
      context 'パラメータが無効な場合' do
        it '400エラーが返ってくること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          post api_v1_clients_path, params: { client: @invalid_client_params }
          expect(response).to have_http_status 400
          expect(JSON.parse(response.body)['message']).to eq '登録出来ません。入力必須項目を確認してください'
        end
        it '登録されない' do
          login_user(user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_clients_path, params: { client: @invalid_client_params }
          end.to_not change(Client, :count) and change(Matter, :count) and change(MatterJoin, :count)
        end
      end
      
      context '子モデルの入力が無効な場合' do
        it '400エラーが返ってくること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          post api_v1_clients_path, params: { client: @invalid_contact_client_params }
          expect(response).to have_http_status 400
          expect(JSON.parse(response.body)['message']).to eq '登録出来ません。入力必須項目を確認してください'
        end
        it '登録されないこと' do
          login_user(user, 'Test-1234', api_v1_login_path)
          expect do
            post api_v1_clients_path, params: { client: @invalid_contact_client_params }
          end.to_not change(Client, :count) and change(Matter, :count) and change(MatterJoin, :count) and change(ContactPhoneNumber, :count)
        end
      end
    end
  end

  describe 'PUT #update' do
    context '正常系' do
      context '事務所ユーザでログイン' do
        context 'クラアント名を更新'
          it 'リクエストが成功すること' do
            login_user(user, 'Test-1234', api_v1_login_path)
            client_params = attributes_for(:client, name: '更新テスト')
            put api_v1_client_path(client), params: { client: client_params }
            expect(response).to have_http_status 200
          end
          it '更新されること' do
            login_user(user, 'Test-1234', api_v1_login_path)
            client_params = attributes_for(:client, name: '更新テスト')
            expect do
              put api_v1_client_path(client), params: { client: client_params }
            end.to change { Client.find(client.id).name }.from('テスト姓').to('更新テスト')
          end
          # it '編集ログが登録されること' do
          #   login_user(belonging_info.user, 'Test-1234', login_path)
          #   client_params = attributes_for(:client, name: '更新テスト')
          #   expect do
          #     put client_path(client), params: { client: client_params }
          #   end.to change(EditLog, :count).by(1)
          # end
        end
        context '子モデルのみ更新' do
          it 'リクエストが成功すること' do
            login_user(user, 'Test-1234', api_v1_login_path)
            contact_phone_number_params = {
              contact_phone_numbers_attributes: {
                "0": attributes_for(:contact_phone_number, phone_number: '08012345678')
              }
            }
            client_params = attributes_for(:client).merge(contact_phone_number_params)
            put api_v1_client_path(client), params: { client: client_params }
            expect(response).to have_http_status 200
          end
  
          it '更新されること' do
            login_user(user, 'Test-1234', api_v1_login_path)
            contact_phone_number_params = {
              contact_phone_numbers_attributes: {
                "0": attributes_for(:contact_phone_number, phone_number: '08012345678')
              }
            }
            client_params = attributes_for(:client).merge(contact_phone_number_params)
            expect do
              put api_v1_client_path(client), params: { client: client_params }
            end.to change { ContactPhoneNumber.find(client.contact_phone_numbers.last.id).phone_number }.from('09012345678').to('08012345678')
          end
        end
      end
    end
    context '準正常系' do
      context '未ログイン状態' do
        it '401エラーが返ってくること' do
          client_params = attributes_for(:client, name: '更新テスト')
          put api_v1_client_path(client), params: { client: client_params }
          expect(response.status).to eq 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
        it '更新されないこと' do
          client_params = attributes_for(:client, name: '更新テスト')
          expect do
            put api_v1_client_path(client), params: { client: client_params }
          end.to_not change { Client.find(client.id).name }.from('テスト姓')
        end
        # it '編集ログが登録されないこと' do
        #   client_params = attributes_for(:client, name: '更新テスト')
        #   expect do
        #     put client_path(client), xhr: true, params: { client: client_params }
        #   end.to_not change(EditLog, :count)
        # end
      end
      context 'パラメータが無効な場合' do
        it '400エラーが返ってくること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          client_params = attributes_for(:client, name: '')
          put api_v1_client_path(client), params: { client: client_params }
          expect(response.status).to eq 400
          expect(JSON.parse(response.body)['message']).to eq '更新出来ません。入力必須項目を確認してください'
        end
        it '更新されないこと' do
          login_user(user, 'Test-1234', api_v1_login_path)
          client_params = attributes_for(:client, name: '')
          expect do
            put api_v1_client_path(client), params: { client: client_params }
          end.to_not change(Client.find(client.id), :name)
        end
  #       # it '編集ログが登録されないこと' do
  #       #   login_user(belonging_info.user, 'Test-1234', login_path)
  #       #   client_params = attributes_for(:client, name: '')
  #       #   expect do
  #       #     put client_path(client), xhr: true, params: { client: client_params }
  #       #   end.to_not change(EditLog, :count)
  #       # end
      end
  #     context '不参加事務所ユーザーでログイン' do
  #       it '403エラーが返ってくること' do
  #         # login_user(belonging_info.user, 'Test-1234', login_path)
  #         client_params = attributes_for(:client, name: '更新テスト')
  #         put client_path(client), params: { client: client_params }
  #         expect(response.status).to eq 302
  #         # expect(response).to redirect_to login_path
  #       end
  #       it '更新されないこと' do
  #         # login_user(belonging_info.user, 'Test-1234', login_path)
  #         client_params = attributes_for(:client, name: '更新テスト')
  #         expect do
  #           put client_path(client), xhr: true, params: { client: client_params }
  #         end.to_not change { Client.find(client.id).name }.from('テスト姓')
  #       end
  #     end
  #     context '不参加ユーザーでログイン' do
  #       it '403エラーが返ってくること' do
  #         login_user(other_belonging_info2.user, 'Test-1234', login_path)
  #         client_params = attributes_for(:client, name: '更新テスト')
  #         put client_path(client), params: { client: client_params }
  #         expect(response.status).to eq 302
  #         expect(response).to redirect_to root_path
  #       end
  #       it '更新されないこと' do
  #         login_user(other_belonging_info2.user, 'Test-1234', login_path)
  #         client_params = attributes_for(:client, name: '更新テスト')
  #         expect do
  #           put client_path(client), xhr: true, params: { client: client_params }
  #         end.to_not change(Client.find(client.id), :name)
  #       end
  #       # it '編集ログが登録されないこと' do
  #       #   login_user(other_belonging_info2.user, 'Test-1234', login_path)
  #       #   client_params = attributes_for(:client, name: '更新テスト')
  #       #   expect do
  #       #     put client_path(client), xhr: true, params: { client: client_params }
  #       #   end.to_not change(EditLog, :count)
  #       # end
  #     end
      context '子モデルの入力が無効な場合' do
        it '400エラーが返ってくること' do
          login_user(user, 'Test-1234', api_v1_login_path)
          contact_phone_number_params = {
            contact_phone_numbers_attributes: {
              "0": attributes_for(:contact_phone_number, phone_number: '08012345')
            }
          }
          client_params = attributes_for(:client).merge(contact_phone_number_params)
          put api_v1_client_path(client), params: { client: client_params }
          expect(response.status).to eq 400
          expect(JSON.parse(response.body)['message']).to eq '更新出来ません。入力必須項目を確認してください'
        end
        it '更新されないこと' do
          login_user(user, 'Test-1234', api_v1_login_path)
          contact_phone_number_params = {
            contact_phone_numbers_attributes: {
              "0": attributes_for(:contact_phone_number, phone_number: '08012345')
            }
          }
          client_params = attributes_for(:client).merge(contact_phone_number_params)
          expect do
            put api_v1_client_path(client), params: { client: client_params }
          end.to_not change { ContactPhoneNumber.find(client.contact_phone_numbers.last.id).phone_number }.from('09012345678')
        end
  #       # it '編集ログが登録されないこと' do
  #       #   login_user(belonging_info.user, 'Test-1234', login_path)
  #       #   contact_phone_number_params = {
  #       #     contact_phone_numbers_attributes: {
  #       #       "0": attributes_for(:contact_phone_number, phone_number: '08012345')
  #       #     }
  #       #   }
  #       #   client_params = attributes_for(:client).merge(contact_phone_number_params)
  #       #   expect do
  #       #     put client_path(client), xhr: true, params: { client: client_params }
  #       #   end.to_not change(EditLog, :count)
  #       # end
    end
  end

  describe 'GET #show' do
    context '正常系' do
      it 'ログイン状態でのリクエストが成功すること' do
        login_user(user, 'Test-1234', api_v1_login_path)
        get api_v1_client_path(client)
        expect(response).to have_http_status 200
      end
      it 'matterへの参加が事務所の場合、同事務所のuserのリクエストが成功すること' do
        login_user(user2, 'Test-1234', api_v1_login_path)
        get api_v1_client_path(client)
        expect(response.status).to eq 200
      end
      it 'matterへの参加があるuserがアクセスする場合リクエストが成功すること' do
        login_user(other_user, 'Test-1234', api_v1_login_path)
        get api_v1_client_path(client)
        expect(response).to have_http_status 200
      end
    end
    context '準正常系' do
      context '未ログイン' do
        it '401エラーを返すこと' do
          get api_v1_client_path(client)
          expect(response).to have_http_status 401
          expect(JSON.parse(response.body)['message']).to eq "Unauthorized"
        end
      end
      context 'client、matterへの参加がないユーザーでログイン' do
        it '403エラーを返すこと' do
          login_user(injoin_user, 'Test-1234', api_v1_login_path)
          get api_v1_client_path(client)
          expect(response).to have_http_status 403
          expect(JSON.parse(response.body)['message']).to eq "Forbidden"
        end
      end
    end
  end
end
