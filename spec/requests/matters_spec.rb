require 'rails_helper'

RSpec.describe 'matters_requests', type: :request do
  let!(:office) { create(:office) }
  let!(:admin_office) { create(:office) }
  let!(:injoin_office) { create(:office) }
  

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin_user) { create(:user) }
  let!(:independent_user) { create(:user) }

  let!(:injoin_independent_user) { create(:user) }
  let!(:injoin_user) { create(:user) }
  let!(:injoin_admin) { create(:user) }

  let!(:matter_category) { create(:matter_category) }

  let!(:client) { create(:client) }
  let!(:matter) { create(:matter, client: client, user: user, matter_category_id: matter_category.id) }
  # let!(:matter_join_office) { create(:matter_join, matter: matter, office: office, belong_side_id: 1, admin: false) }
  # let!(:matter_join_admin_office) { create(:matter_join, matter: matter, office: admin_office, belong_side_id: 1) }
  # let!(:matter_join_user) { create(:matter_join, matter: matter, user: independent_matter_user, belong_side_id: 2, admin: false) }
  # let!(:matter_join_admin) { create(:matter_join, matter: matter, user: independent_matter_admin, belong_side_id: 2) }
  # let!(:client_join_office) { create(:client_join, client: client, office: office, belong_side_id: 1, admin: false) }
  # let!(:client_join_admin_office) { create(:client_join, client: client, office: admin_office, belong_side_id: 1) }
  # let!(:client_join_user) { create(:client_join, client: client, user: independent_client_user, belong_side_id: 2, admin: false) }
  # let!(:client_join_admin_user) { create(:client_join, client: client, user: independent_client_admin, belong_side_id: 2) }
  
  let!(:belonging_info) { create(:belonging_info, user: user, office: office) }
  let!(:other_belonging_info) { create(:belonging_info, user: other_user, office: office) }
  let!(:office_admin_belonging_info) { create(:belonging_info, user: user, office: office, admin: true) }

  describe 'POST #create' do
    before do
      contact_phone_number_params = {contact_phone_numbers_attributes: { "0": attributes_for(:contact_phone_number)}}
      invalid_contact_phone_number_params = { contact_phone_numbers_attributes: {"0": attributes_for(:contact_phone_number, phone_number: '123456') }}
      contact_email_params = { contact_emails_attributes: { "0": attributes_for(:contact_email) }  }
      contact_address_params = { contact_addresss_attributes: {  "0": attributes_for(:contact_address)}}
      @opponent_params = {opponents_attributes: { "0": attributes_for(:opponent)}}
      @contact_opponent_params = {opponents_attributes: { "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params) }}
      @matter_admin_office_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, office_id: office.id) }}
      @matter_admin_user_params = { matter_joins_attributes: { "0": attributes_for(:matter_join, user_id: independent_user.id) }}
      # @matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(opponent_params, matter_join_params) } }
      # @min_matter_params = { matters_attributes: { "0": attributes_for(:matter, user_id: user.id, matter_category_id: matter_category.id).merge(matter_join_params) }}
      # @contact_matter_params = {matters_attributes: { "0": attributes_for(:matter, user_id: user.id).merge(contact_opponent_params, matter_join_params)}}
      
    end
    context '正常系' do
      context 'クライアント管理事務所ユーザーでログイン' do
        context '案件、相手方等、相手方連絡先を入力' do
          it 'リクエストが成功すること' do
            login_user(admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge( @matter_admin_office_params, @contact_opponent_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge( @matter_admin_office_params, @contact_opponent_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(
              ContactEmail, :count).by(1) and change(ContactAddress, :count).by(1) and change(
                ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1)
          end
        end
        context '案件のみ入力' do
          it 'リクエストが成功すること' do
            login_user(admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge( @matter_admin_office_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge( @matter_admin_office_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          end
          # it 'ログイン状態の場合、ログが登録されること' do
          #   login_user(belonging_info.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   expect do
          #     post client_matters_path(client), params: { matter: matter_params }
          #   end.to change(EditLog, :count).by(1)
          # end
        end
      end
      context 'クライアント管理個人ユーザーでログイン' do
        context '案件、相手方等、相手方連絡先を入力' do
          it 'リクエストが成功すること' do
            login_user(independent_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params, @contact_opponent_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params, @contact_opponent_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(Opponent, :count).by(1) and change(
              ContactEmail, :count).by(1) and change(ContactAddress, :count).by(1) and change(
                ContactPhoneNumber, :count).by(1) and change(MatterJoin, :count).by(1)
          end
        end
        context '案件のみ入力' do
          it 'リクエストが成功すること' do
            login_user(admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params)
            post api_v1_client_matters_path(client), params: { matter: matter_params }
            expect(response).to have_http_status 200
          end
          it '登録されること' do
            login_user(admin_user, 'Test-1234', api_v1_login_path)
            matter_params = attributes_for(:matter, matter_category_id: matter_category.id
              ).merge(@matter_admin_user_params)
            expect do
              post api_v1_client_matters_path(client), params: { matter: matter_params }
            end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          end
        end

          # it 'matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者)の場合、登録されること' do
          #   login_user(other_belonging_info.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   expect do
          #     post client_matters_path(client), params: { matter: matter_params }
          #   end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          # end
          # it 'matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者でない)の場合、リクエストが成功すること' do
          #   login_user(other_belonging_info4.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   post client_matters_path(client), params: { matter: matter_params }
          #   expect(response).to have_http_status 302
          #   expect(response).to redirect_to matter_path(Matter.last)
          # end
          # it 'matterへの参加(matter_join管理者、個人参加)がある他事務所user(belonging_info管理者でない)の場合、登録されること' do
          #   login_user(other_belonging_info4.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   expect do
          #     post client_matters_path(client), params: { matter: matter_params }
          #   end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          # end
          # it 'matterへの参加(matter_join管理者でない、事務所参加)がある他事務所user(belonging_info管理者)の場合、リクエストが成功すること' do
          #   login_user(other2_belonging_info.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   post client_matters_path(client), params: { matter: matter_params }
          #   expect(response).to have_http_status 302
          #   expect(response).to redirect_to matter_path(Matter.last)
          # end
          # it 'matterへの参加(matter_join管理者でない、事務所参加)がある他事務所user(belonging_info管理者)の場合、登録されること' do
          #   login_user(other2_belonging_info.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   expect do
          #     post client_matters_path(client), params: { matter: matter_params }
          #   end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          # end
          # it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者)の場合、リクエストが成功すること' do
          #   login_user(other_belonging_info3.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   post client_matters_path(client), params: { matter: matter_params }
          #   expect(response).to have_http_status 302
          #   expect(response).to redirect_to matter_path(Matter.last)
          # end
          # it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者)の場合、登録されること' do
          #   login_user(other_belonging_info3.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   expect do
          #     post client_matters_path(client), params: { matter: matter_params }
          #   end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          # end
          # it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者でない)の場合、リクエストが成功すること' do
          #   login_user(other_belonging_info5.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   post client_matters_path(client), params: { matter: matter_params }
          #   expect(response).to have_http_status 302
          #   expect(response).to redirect_to matter_path(Matter.last)
          # end
          # it 'matterへの参加(matter_join管理者でない、個人参加)がある他事務所user(belonging_info管理者でない)の場合、登録されること' do
          #   login_user(other_belonging_info5.user, 'Test-1234', login_path)
          #   matter_join_params = {
          #     matter_joins_attributes: {
          #       "0": attributes_for(:matter_join)
          #     }
          #   }
          #   matter_params = attributes_for(:matter).merge(matter_join_params)
          #   expect do
          #     post client_matters_path(client), params: { matter: matter_params }
          #   end.to change(Matter, :count).by(1) and change(MatterJoin, :count).by(1)
          # end
          # xit 'tagを入力した場合、タグが登録されること' do
          #   login_user(belonging_info.user, 'Test-1234', login_path)
          #   matter_params = attributes_for(:matter).merge(opponent_params)
          #   expect do
          #     post client_matters_path(client), params: { matter: matter_params }
          #   end.to change(Matter, :count).by(1)
          # end
        # end
      end
    end
    # context '準正常系' do
    #   context '未ログイン状態の場合' do
    #     it 'ログイン画面にリダイレクトされること' do
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter).merge(matter_join_params, opponent_params)
    #       post client_matters_path(client), params: { matter: matter_params }
    #       expect(response).to have_http_status 302
    #       expect(response).to redirect_to login_path
    #     end
    #     it '登録されない' do
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter).merge(matter_join_params, opponent_params)
    #       expect do
    #         post client_matters_path(client), xhr: true, params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count) and change(EditLog, :count)
    #     end
    #   end
    #   context 'パラメータが無効な場合' do
    #     it 'リクエストが成功すること' do
    #       login_user(belonging_info.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter, matter_status_id: '').merge(matter_join_params, opponent_params)
    #       post client_matters_path(client), xhr: true, params: { matter: matter_params }
    #       expect(response).to have_http_status 200
    #     end
    #     it '登録されない' do
    #       login_user(belonging_info.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter, matter_status_id: '').merge(matter_join_params, opponent_params)
    #       expect do
    #         post client_matters_path(client), xhr: true, params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count) and change(EditLog, :count)
    #     end
    #   end
    #   context 'officeの登録がない場合' do
    #     xit '〇〇にリダイレクトされること' do
    #       # login_user(belonging_info.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter).merge(matter_join_params, opponent_params)
    #       post client_matters_path(client), params: { matter: matter_params }
    #       # expect(response).to redirect_to login_path
    #     end
    #     xit '登録されない' do
    #       # login_user(belonging_info.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter).merge(matter_join_params, opponent_params)
    #       expect do
    #         post client_matters_path(client), xhr: true, params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count) and change(EditLog, :count)
    #     end
    #   end
    #   context 'matter_joinが無効な場合' do
    #     it 'リクエストが成功すること' do
    #       login_user(belonging_info.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join, belong_side_id: '')
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter, matter_status_id: '').merge(matter_join_params, opponent_params)
    #       post client_matters_path(client), xhr: true, params: { matter: matter_params }
    #       expect(response).to have_http_status 200
    #     end
    #     it '登録されない' do
    #       login_user(belonging_info.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join, belong_side_id: '')
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter, matter_status_id: '').merge(matter_join_params, opponent_params)
    #       expect do
    #         post client_matters_path(client), xhr: true, params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count) and change(EditLog, :count)
    #     end
    #   end
    #   context 'matterへの参加がない場合' do
    #     it 'トップページにリダイレクトされること' do
    #       login_user(belonging_info.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter).merge(matter_join_params, opponent_params)
    #       post client_matters_path(other_client), params: { matter: matter_params }
    #       expect(response.status).to eq 302
    #       expect(response).to redirect_to root_path
    #     end
    #     it '登録されない' do
    #       login_user(belonging_info.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter).merge(matter_join_params, opponent_params)
    #       expect do
    #         post client_matters_path(other_client), xhr: true, params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count) and change(EditLog, :count)
    #     end
    #   end
    #   context 'matterへの参加がない他事務所userの場合' do
    #     it 'トップページにリダイレクトされること' do
    #       login_user(other_belonging_info2.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter).merge(matter_join_params, opponent_params)
    #       post client_matters_path(client), params: { matter: matter_params }
    #       expect(response.status).to eq 302
    #       expect(response).to redirect_to root_path
    #     end
    #     it '登録されない' do
    #       login_user(other_belonging_info2.user, 'Test-1234', login_path)
    #       matter_join_params = {
    #         matter_joins_attributes: {
    #           "0": attributes_for(:matter_join)
    #         }
    #       }
    #       contact_phone_number_params = {
    #         contact_phone_numbers_attributes: {
    #           "0": attributes_for(:contact_phone_number)
    #         }
    #       }
    #       contact_email_params = {
    #         contact_emails_attributes: {
    #           "0": attributes_for(:contact_email)
    #         }
    #       }
    #       contact_address_params = {
    #         contact_addresss_attributes: {
    #           "0": attributes_for(:contact_address)
    #         }
    #       }
    #       opponent_params = {
    #         opponents_attributes: {
    #           "0": attributes_for(:opponent).merge(contact_phone_number_params, contact_email_params, contact_address_params)
    #         }
    #       }
    #       matter_params = attributes_for(:matter).merge(matter_join_params, opponent_params)
    #       expect do
    #         post client_matters_path(client), xhr: true, params: { matter: matter_params }
    #       end.to_not change(Matter, :count) and change(MatterJoin, :count) and change(Opponent, :count) and change(ContactEmail, :count) and change(ContactAddress, :count) and change(ContactPhoneNumber, :count) and change(EditLog, :count)
    #     end
    #   end
    # end
  end
end


  
