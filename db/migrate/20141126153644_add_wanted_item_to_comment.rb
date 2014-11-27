class AddWantedItemToComment < ActiveRecord::Migration
  def change
    add_reference :comments, :wanted_item, index: true
  end
end
