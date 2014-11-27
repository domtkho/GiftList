class AddPriorityToWantedItem < ActiveRecord::Migration
  def change
    add_column :wanted_items, :priority, :integer, :default => 3
  end
end
