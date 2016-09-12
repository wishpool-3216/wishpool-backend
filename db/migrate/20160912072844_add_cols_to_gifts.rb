class AddColsToGifts < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      add_column :gifts, :publicity, :integer
      add_column :gifts, :expiry, :date
      add_column :gifts, :description, :text
      add_attachment :gifts, :image
    end
  end
end
