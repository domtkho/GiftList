class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.references :user, index: true
      t.references :wanted_item, index: true
      t.float :amount

      t.timestamps
    end
  end
end
