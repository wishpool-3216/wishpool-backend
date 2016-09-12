class AddContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.references :gift, foreign_key: true, index: true
      t.float :amount

      t.timestamps
      t.userstamps
    end
  end
end
