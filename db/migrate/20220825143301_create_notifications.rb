class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.integer :matter_id
      t.integer :task_id
      t.string :action, default: '', null: false
      t.boolean :checked, default: false, null: false
      t.timestamps
    end
    add_index :notifications, :sender_id
    add_index :notifications, :receiver_id
    add_index :notifications, :matter_id
    add_index :notifications, :task_id
  end
end
