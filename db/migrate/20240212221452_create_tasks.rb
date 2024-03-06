class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks ,id: :uuid do  |t|
      t.string :title
      t.string :des
      t.date :due_date

      t.timestamps
    end
  end
end
