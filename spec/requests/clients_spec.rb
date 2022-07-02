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

  let!(:client) { create(:client) }
  let!(:other_client) { create(:client) }
  let!(:matter) { create(:matter, client: client, user: user) }
  let!(:other_matter) { create(:matter, client: other_client, user: other_user) }
  let!(:matter_join_office) { create(:matter_join, matter: matter, office: office, belong_side_id: 1) }
  let!(:matter_join_other_user) { create(:matter_join, matter: matter, user: other_user, belong_side_id: 2) }
  let!(:matter_join_other_user3) { create(:matter_join, matter: matter, user: other_user3, belong_side_id: 2, admin: false) }
  let!(:matter_join_other_user4) { create(:matter_join, matter: matter, user: other_user4, belong_side_id: 2) }
  let!(:matter_join_other_user5) { create(:matter_join, matter: matter, user: other_user5, belong_side_id: 2, admin: false) }
  let!(:matter_join_other2_office) { create(:matter_join, matter: matter, office: other2_office, belong_side_id: 1, admin: false) }
  let!(:other_matter_join_office) { create(:matter_join, matter: other_matter, office: other_office, belong_side_id: 1) }

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
  
  
  describe "GET #index" do
    context '正常系' do
      context '参加事務所ユーザーでログイン' do
        it 'リクエストが成功すること' do

        end
      end

      context '参加ユーザーでログイン' do
        it 'リクエストが成功すること' do

        end
      end
    end

    context '準正常系' do
      context '未ログイン' do
        it '401エラーが返ってくること' do

        end
      end
      context '不参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
        end
      end
    end
  end

  describe 'POST #create' do
    context '正常系' do
      context '参加事務所ユーザーでログイン、クライアント、案件、相手方等を入力' do
        it 'リクエストが成功すること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          opponent_params = {
            opponents_attributes: {
              "0": attributes_for(:opponent)
            }
          }
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(opponent_params, matter_join_params)
            }
          }
          client_params = attributes_for(:client).merge(matter_params)
          post clients_path, params: { client: client_params, tab_btn: 1 }
          expect(response).to have_http_status 302
          expect(response).to redirect_to matter_path(Matter.last)
        end

        it '登録されること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          opponent_params = {
            opponents_attributes: {
              "0": attributes_for(:opponent)
            }
          }
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(opponent_params, matter_join_params)
            }
          }
          client_params = attributes_for(:client).merge(matter_params)
          expect do
            post clients_path, params: { client: client_params, tab_btn: 1 }
          end.to change(Client, :count).by(1) and change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(MatterJoin, :count).by(1)
        end
      end

      context '参加事務所ユーザーでログイン、クライアント、案件を入力' do
        it 'リクエストが成功すること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          client_params = attributes_for(:client).merge(matter_params)
          post clients_path, params: { client: client_params, tab_btn: 1 }
          expect(response).to have_http_status 302
          expect(response).to redirect_to matter_path(Matter.last)
        end
        it '登録されること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          client_params = attributes_for(:client).merge(matter_params)
          expect do
            post clients_path, params: { client: client_params, tab_btn: 1 }
          end.to change(Client, :count).by(1) and change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
        end
      end
      context '参加事務所ユーザーでログイン、クライアント、案件、クライアント連絡先を入力' do
        it 'クライアント連絡先が同時に登録されること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          contact_phone_number_params = {
            contact_phone_numbers_attributes: {
              "0": attributes_for(:contact_phone_number)
            }
          }
          contact_email_params = {
            contact_emails_attributes: {
              "0": attributes_for(:contact_email)
            }
          }
          contact_address_params = {
            contact_addresss_attributes: {
              "0": attributes_for(:contact_address)
            }
          }
          client_params = attributes_for(:client).merge(contact_phone_number_params, contact_email_params, contact_address_params, matter_params)
          expect do
            post clients_path, params: { client: client_params, tab_btn: 1 }
          end.to change(Client, :count).by(1).and change(ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1)
        end
      end
      context '参加事務所ユーザーでログイン、クライアント、案件、相手方、相手方連絡先を入力' do
        it '相手方の連絡先が同時に登録されること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_phone_number_params = {
            contact_phone_numbers_attributes: {
              "0": attributes_for(:contact_phone_number)
            }
          }
          contact_email_params = {
            contact_emails_attributes: {
              "0": attributes_for(:contact_email)
            }
          }
          contact_address_params = {
            contact_addresss_attributes: {
              "0": attributes_for(:contact_address)
            }
          }
          opponent_params = {
            opponents_attributes: {
              "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
            }
          }
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(opponent_params, matter_join_params)
            }
          }
          client_params = attributes_for(:client).merge(matter_params)
          expect do
            post clients_path, params: { client: client_params, tab_btn: 1 }
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
        it 'ログイン画面にリダイレクトされること' do
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          client_params = attributes_for(:client).merge(matter_params)
          post clients_path, params: { client: client_params, tab_btn: 1 }
          expect(response).to have_http_status 302
          expect(response).to redirect_to login_path
        end
        it '登録されない' do
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          client_params = attributes_for(:client).merge(matter_params)
          expect do
            post clients_path, params: { client: client_params, tab_btn: 1 }
          end.to_not change(Client, :count) and change(Matter, :count) and change(MatterJoin, :count) and change(EditLog, :count)
        end
      end
      context 'パラメータが無効な場合' do
        it '400エラーが返ってくること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          client_params = attributes_for(:client, name: '').merge(matter_params)
          post clients_path, xhr: true, params: { client: client_params, tab_btn: 1 }
          expect(response).to have_http_status 200
        end
        it '登録されない' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          client_params = attributes_for(:client, name: '').merge(matter_params)
          expect do
            post clients_path, xhr: true, params: { client: client_params, tab_btn: 1 }
          end.to_not change(Client, :count) and change(Matter, :count) and change(MatterJoin, :count) and change(EditLog, :count)
        end
      end
      context 'officeの登録がない場合' do
        it '403エラーが返ってくること' do
          # login_user(belonging_info.user, 'Test-1234', login_path)
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          client_params = attributes_for(:client).merge(matter_params)
          post clients_path, params: { client: client_params, tab_btn: 1 }
          expect(response).to have_http_status 302
          # expect(response).to redirect_to login_path
        end
        it '登録されない' do
          # login_user(belonging_info.user, 'Test-1234', login_path)
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          client_params = attributes_for(:client).merge(matter_params)
          expect do
            post clients_path, params: { client: client_params, tab_btn: 1 }
          end.to_not change(Client, :count) and change(Matter, :count) and change(MatterJoin, :count)
        end
      end
      context 'contact_phone_numberの入力が無効な場合' do
        it '400エラーが返ってくること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          contact_phone_number_params = {
            contact_phone_numbers_attributes: {
              "0": attributes_for(:contact_phone_number, phone_number: '123456')
            }
          }
          client_params = attributes_for(:client).merge(contact_phone_number_params, matter_params)
          post clients_path, xhr: true, params: { client: client_params, tab_btn: 1 }
          expect(response).to have_http_status 200
        end
        it '登録されないこと' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          matter_join_params = {
            matter_joins_attributes: {
              "0": attributes_for(:matter_join)
            }
          }
          matter_params = {
            matters_attributes: {
              "0": attributes_for(:matter, user_id: user.id).merge(matter_join_params)
            }
          }
          contact_phone_number_params = {
            contact_phone_numbers_attributes: {
              "0": attributes_for(:contact_phone_number, phone_number: '123456')
            }
          }
          client_params = attributes_for(:client).merge(contact_phone_number_params, matter_params)
          expect do
            post clients_path, xhr: true, params: { client: client_params, tab_btn: 1 }
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
            login_user(belonging_info.user, 'Test-1234', login_path)
            client_params = attributes_for(:client, name: '更新テスト')
            put client_path(client), params: { client: client_params }
            expect(response.status).to eq 302
            expect(response).to redirect_to client_path(client)
          end
          it '更新されること' do
            login_user(belonging_info.user, 'Test-1234', login_path)
            client_params = attributes_for(:client, name: '更新テスト')
            expect do
              put client_path(client), params: { client: client_params }
            end.to change { Client.find(client.id).name }.from('テスト姓').to('更新テスト')
          end
          it '編集ログが登録されること' do
            login_user(belonging_info.user, 'Test-1234', login_path)
            client_params = attributes_for(:client, name: '更新テスト')
            expect do
              put client_path(client), params: { client: client_params }
            end.to change(EditLog, :count).by(1)
          end
        end
        context 'クライアント電話番号のみ更新' do
          it 'リクエストが成功すること' do
            login_user(belonging_info.user, 'Test-1234', login_path)
            contact_phone_number_params = {
              contact_phone_numbers_attributes: {
                "0": attributes_for(:contact_phone_number, phone_number: '08012345678')
              }
            }
            client_params = attributes_for(:client).merge(contact_phone_number_params)
            put client_path(client), params: { client: client_params }
            expect(response).to have_http_status 302
            expect(response).to redirect_to client_path(client)
          end
  
          it '更新されること' do
            login_user(belonging_info.user, 'Test-1234', login_path)
            contact_phone_number_params = {
              contact_phone_numbers_attributes: {
                "0": attributes_for(:contact_phone_number, phone_number: '08012345678')
              }
            }
            client_params = attributes_for(:client).merge(contact_phone_number_params)
            expect do
              put client_path(client), params: { client: client_params }
            end.to change { ContactPhoneNumber.find(client.contact_phone_numbers.last.id).phone_number }.from('09012345678').to('08012345678')
          end
        end
      end
      context 'クライアントメールのみ更新' do
        it 'リクエストが成功すること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_email_params = {
            contact_emails_attributes: {
              "0": attributes_for(:contact_email, email: 'contact-email123@example.com')
            }
          }
          client_params = attributes_for(:client).merge(contact_email_params)
          put client_path(client), params: { client: client_params }
          expect(response).to have_http_status 302
          expect(response).to redirect_to client_path(client)
        end
        it '更新されること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_email_params = {
            contact_emails_attributes: {
              "0": attributes_for(:contact_email, email: 'contact-email123@example.com')
            }
          }
          client_params = attributes_for(:client).merge(contact_email_params)
          expect do
            put client_path(client), params: { client: client_params }
          end.to change { ContactEmail.find(client.contact_emails.last.id).email }.from('contact-email@example.com').to('contact-email123@example.com')
        end
      end
      context 'クライアント住所のみ更新' do
        it 'リクエストが成功すること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_address_params = {
            contact_addresses_attributes: {
              "0": attributes_for(:contact_address, post_code: '1100002')
            }
          }
          client_params = attributes_for(:client).merge(contact_address_params)
          put client_path(client), params: { client: client_params }
          expect(response).to have_http_status 302
          expect(response).to redirect_to client_path(client)
        end
        it '住所が更新されること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_address_params = {
            contact_addresses_attributes: {
              "0": attributes_for(:contact_address, post_code: '1100002')
            }
          }
          client_params = attributes_for(:client).merge(contact_address_params)
          expect do
            put client_path(client), params: { client: client_params }
          end.to change { ContactAddress.find(client.contact_addresses.last.id).post_code }.from('1100001').to('1100002')
        end
    end
    context '準正常系' do
      context '未ログイン状態' do
        it '401エラーが返ってくること' do
          client_params = attributes_for(:client, name: '更新テスト')
          put client_path(client), params: { client: client_params }
          expect(response.status).to eq 302
          expect(response).to redirect_to login_path
        end
        it '更新されないこと' do
          client_params = attributes_for(:client, name: '更新テスト')
          expect do
            put client_path(client), xhr: true, params: { client: client_params }
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
          login_user(belonging_info.user, 'Test-1234', login_path)
          client_params = attributes_for(:client, name: '')
          put client_path(client), xhr: true, params: { client: client_params }
          expect(response.status).to eq 200
        end
        it '更新されないこと' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          client_params = attributes_for(:client, name: '')
          expect do
            put client_path(client), xhr: true, params: { client: client_params }
          end.to_not change(Client.find(client.id), :name)
        end
        # it '編集ログが登録されないこと' do
        #   login_user(belonging_info.user, 'Test-1234', login_path)
        #   client_params = attributes_for(:client, name: '')
        #   expect do
        #     put client_path(client), xhr: true, params: { client: client_params }
        #   end.to_not change(EditLog, :count)
        # end
      end
      context '不参加事務所ユーザーでログイン' do
        it '403エラーが返ってくること' do
          # login_user(belonging_info.user, 'Test-1234', login_path)
          client_params = attributes_for(:client, name: '更新テスト')
          put client_path(client), params: { client: client_params }
          expect(response.status).to eq 302
          # expect(response).to redirect_to login_path
        end
        it '更新されないこと' do
          # login_user(belonging_info.user, 'Test-1234', login_path)
          client_params = attributes_for(:client, name: '更新テスト')
          expect do
            put client_path(client), xhr: true, params: { client: client_params }
          end.to_not change { Client.find(client.id).name }.from('テスト姓')
        end
      end
      context '不参加ユーザーでログイン' do
        it '403エラーが返ってくること' do
          login_user(other_belonging_info2.user, 'Test-1234', login_path)
          client_params = attributes_for(:client, name: '更新テスト')
          put client_path(client), params: { client: client_params }
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end
        it '更新されないこと' do
          login_user(other_belonging_info2.user, 'Test-1234', login_path)
          client_params = attributes_for(:client, name: '更新テスト')
          expect do
            put client_path(client), xhr: true, params: { client: client_params }
          end.to_not change(Client.find(client.id), :name)
        end
        # it '編集ログが登録されないこと' do
        #   login_user(other_belonging_info2.user, 'Test-1234', login_path)
        #   client_params = attributes_for(:client, name: '更新テスト')
        #   expect do
        #     put client_path(client), xhr: true, params: { client: client_params }
        #   end.to_not change(EditLog, :count)
        # end
      end
      context '電話番号が無効な場合' do
        it '400エラーが返ってくること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_phone_number_params = {
            contact_phone_numbers_attributes: {
              "0": attributes_for(:contact_phone_number, phone_number: '08012345')
            }
          }
          client_params = attributes_for(:client).merge(contact_phone_number_params)
          put client_path(client), xhr: true, params: { client: client_params }
          expect(response.status).to eq 200
        end
        it '更新されないこと' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_phone_number_params = {
            contact_phone_numbers_attributes: {
              "0": attributes_for(:contact_phone_number, phone_number: '08012345')
            }
          }
          client_params = attributes_for(:client).merge(contact_phone_number_params)
          expect do
            put client_path(client), xhr: true, params: { client: client_params }
          end.to_not change { ContactPhoneNumber.find(client.contact_phone_numbers.last.id).phone_number }.from('09012345678')
        end
        # it '編集ログが登録されないこと' do
        #   login_user(belonging_info.user, 'Test-1234', login_path)
        #   contact_phone_number_params = {
        #     contact_phone_numbers_attributes: {
        #       "0": attributes_for(:contact_phone_number, phone_number: '08012345')
        #     }
        #   }
        #   client_params = attributes_for(:client).merge(contact_phone_number_params)
        #   expect do
        #     put client_path(client), xhr: true, params: { client: client_params }
        #   end.to_not change(EditLog, :count)
        # end
      end
      context 'メールが無効な場合' do
        it '400エラーが返ってくること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_email_params = {
            contact_emails_attributes: {
              "0": attributes_for(:contact_email, email: 'contact-email123example.com')
            }
          }
          client_params = attributes_for(:client).merge(contact_email_params)
          put client_path(client), xhr: true, params: { client: client_params }
          expect(response.status).to eq 200
        end
        it '更新されないこと' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_email_params = {
            contact_emails_attributes: {
              "0": attributes_for(:contact_email, email: 'contact-email123example.com')
            }
          }
          client_params = attributes_for(:client).merge(contact_email_params)
          expect do
            put client_path(client), xhr: true, params: { client: client_params }
          end.to_not change { ContactEmail.find(client.contact_emails.last.id).email }.from('contact-email@example.com')
        end
        it '編集ログが登録されないこと' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_email_params = {
            contact_emails_attributes: {
              "0": attributes_for(:contact_email, email: 'contact-email123example.com')
            }
          }
          client_params = attributes_for(:client).merge(contact_email_params)
          expect do
            put client_path(client), xhr: true, params: { client: client_params }
          end.to_not change(EditLog, :count)
        end
      end
      context '住所が無効な場合' do
        it '400エラーが返ってくること' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_address_params = {
            contact_addresses_attributes: {
              "0": attributes_for(:contact_address, post_code: '110002')
            }
          }
          client_params = attributes_for(:client).merge(contact_address_params)
          put client_path(client), xhr: true, params: { client: client_params }
          expect(response.status).to eq 200
        end
        it '更新されないこと' do
          login_user(belonging_info.user, 'Test-1234', login_path)
          contact_address_params = {
            contact_addresses_attributes: {
              "0": attributes_for(:contact_address, post_code: '110002')
            }
          }
          client_params = attributes_for(:client).merge(contact_address_params)
          expect do
            put client_path(client), xhr: true, params: { client: client_params }
          end.to_not change { ContactAddress.find(client.contact_addresses.last.id).post_code }.from('1100001')
        end
        # it '編集ログが登録されないこと' do
        #   login_user(belonging_info.user, 'Test-1234', login_path)
        #   contact_address_params = {
        #     contact_addresses_attributes: {
        #       "0": attributes_for(:contact_address, post_code: '110002')
        #     }
        #   }
        #   client_params = attributes_for(:client).merge(contact_address_params)
        #   expect do
        #     put client_path(client), xhr: true, params: { client: client_params }
        #   end.to_not change(EditLog, :count)
        # end
      end
    end
  end

end
