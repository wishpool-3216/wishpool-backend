class AddColsToUsers < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      add_column :users, :birthday, :date
    end
  end
end
