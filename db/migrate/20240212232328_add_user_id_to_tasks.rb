class AddUserIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :user_id, :uuid
  end
end
