class RemoveNameFromSections < ActiveRecord::Migration[7.0]
  def change
    remove_column :sections, :name, :string
  end
end
