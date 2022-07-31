class CreateWorkLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :work_logs do |t|
      t.integer :working_time
      t.text :content, null: false
      t.date :worked_date, null: false
      t.boolean :detail_reflection, null: false, default: true
      t.references :user, null: false, foreign_key: true
      t.references :matter, foreign_key: true
      t.references :task, foreign_key: true
      t.references :fee, foreign_key: true
      t.timestamps
    end
  end
end
