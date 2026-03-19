class AddNameToDevices < ActiveRecord::Migration[6.1]
  def change
    add_column :devices, :name, :string
  end
end
