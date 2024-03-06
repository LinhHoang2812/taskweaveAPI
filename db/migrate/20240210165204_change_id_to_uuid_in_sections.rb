class ChangeIdToUuidInSections < ActiveRecord::Migration[7.0]
  def change
    remove_column :sections, :id
    add_column :sections, :id, :uuid, default: "gen_random_uuid()", primary_key: true
  end
end
