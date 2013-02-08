class AddUserIndexes < ActiveRecord::Migration
  def change
    add_index :users, :email, :unique => true
    add_index :users, :username, :username => true
    add_index :users, :name
  end
end