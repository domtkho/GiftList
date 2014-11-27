class AddPriorityToWantedItem < ActiveRecord::Migration
  def change
    add_column :wanted_items, :priority, :integer
  end
end
