class AddNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true, index: true
      t.boolean :read, index: true
      t.text :message
      t.text :link
    end
  end
end
