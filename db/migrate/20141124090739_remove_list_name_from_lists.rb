class RemoveListNameFromLists < ActiveRecord::Migration
  def change
    remove_column :lists, :list_name, :string
  end
end
