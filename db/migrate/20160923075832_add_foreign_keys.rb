class AddForeignKeys < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      add_foreign_key :gifts, :users, column: :creator_id, index: true
      add_foreign_key :gifts, :users, column: :updater_id, index: true

      add_foreign_key :contributions, :users, column: :creator_id, index: true
      add_foreign_key :contributions, :users, column: :updater_id, index: true
    end
  end
end
