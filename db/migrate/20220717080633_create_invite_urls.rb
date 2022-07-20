class CreateInviteUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :invite_urls do |t|
      t.string :token, null: false
      t.boolean :admin, default: false
      t.datetime :limit_date, null: false
      t.boolean :join, default: false
      t.references :user, null: false, foreign_key: true
      t.references :client, foreign_key: true
      t.references :matter, foreign_key: true
      t.timestamps
    end
  end
end
