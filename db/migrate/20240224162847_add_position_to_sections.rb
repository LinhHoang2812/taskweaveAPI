class AddPositionToSections < ActiveRecord::Migration[7.0]
  def change
    add_column :sections, :position, :integer
  end
end
