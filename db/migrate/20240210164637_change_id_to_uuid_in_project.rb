class ChangeIdToUuidInProject < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :id
    add_column :projects, :id, :uuid, default: "gen_random_uuid()", primary_key: true
  end
end
