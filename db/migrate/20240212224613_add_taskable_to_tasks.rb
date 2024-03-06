class AddTaskableToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :taskable_id, :uuid
    add_column :tasks, :taskable_type, :string
    add_index :tasks, [:taskable_type, :taskable_id]
  end
end
