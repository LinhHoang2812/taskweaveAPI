class AddProjectIdToSections < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :project_id, :uuid
  end
end
