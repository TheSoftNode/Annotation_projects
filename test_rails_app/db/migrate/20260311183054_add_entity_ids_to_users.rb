class AddEntityIdsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :entity_ids, :text
  end
end
