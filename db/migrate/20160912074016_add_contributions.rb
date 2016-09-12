class AddContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.references :user, foreign_key: true, index: true
      t.references :gift, foreign_key: true, index: true
      t.float :amount

      t.timestamps
      t.userstamps
    end
  end
end
