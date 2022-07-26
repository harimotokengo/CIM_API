class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.datetime :deadline
      t.integer :task_status, null: false
      t.integer :priority, null: false
      t.text :description
      t.boolean :complete, default: false, null: false
      t.boolean :archive, default: true, null: false
      t.references :user, null: false, foreign_key: true
      t.references :matter, foreign_key: true
      t.references :work_stage, null: false, foreign_key: true
      # t.references :fee, foreign_key: true
      t.timestamps
    end
  end
end
