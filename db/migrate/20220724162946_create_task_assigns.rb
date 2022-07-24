class CreateTaskAssigns < ActiveRecord::Migration[7.0]
  def change
    create_table :task_assigns do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.timestamps
    end
  end
end
