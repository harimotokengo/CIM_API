class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email,            null: false
      t.string :crypted_password
      t.string :reset_password_token, default: nil
      t.datetime :reset_password_token_expires_at, default: nil
      t.datetime :reset_password_email_sent_at, default: nil
      t.integer :access_count_to_reset_password_page, default: 0
      t.integer :failed_logins_count, default: 0
      t.datetime :lock_expires_at, default: nil
      t.string :unlock_token, default: nil
      t.string :salt
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :last_name_kana, null: false
      t.string :first_name_kana, null: false
      t.integer :membership_number
      t.integer :user_job_id, null: false
      t.integer :office_id
      t.boolean :archive, default: true, null: false
      t.timestamps                null: false
    end

    add_index :users, :reset_password_token
    add_index :users, :unlock_token
    add_index :users, :email, unique: true
  end
end
