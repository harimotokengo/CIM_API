class CreateWorkStages < ActiveRecord::Migration[7.0]
  def change
    create_table :work_stages do |t|
      t.string :name, nul: false
      t.timestamps
    end
  end
end
