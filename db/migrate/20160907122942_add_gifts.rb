class AddGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :name
      t.float :expected_price

      t.timestamps
      t.userstamps
    end
  end
end
