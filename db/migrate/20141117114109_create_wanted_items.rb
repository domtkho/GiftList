class CreateWantedItems < ActiveRecord::Migration
  def change
    create_table :wanted_items do |t|
      t.references :user
      t.references :list
      t.references :item
      t.integer :item_priority

      t.timestamps
    end
  end
end
