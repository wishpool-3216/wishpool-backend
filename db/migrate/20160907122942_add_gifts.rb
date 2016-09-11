class AddGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :name
      t.float :expected_price

      t.integer :recipient_id

      t.timestamps
      t.userstamps
    end

    add_foreign_key :gifts, :users, column: :recipient_id
    add_index :gifts, :recipient_id
  end
end
