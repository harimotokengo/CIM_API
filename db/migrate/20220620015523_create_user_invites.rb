class CreateUserInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :user_invites do |t|
      t.integer :sender_id, null: false
      t.string :token, null: false
      t.datetime :limit_date, null: false
      t.boolean :join, default: false
      t.timestamps
    end
  end
end
