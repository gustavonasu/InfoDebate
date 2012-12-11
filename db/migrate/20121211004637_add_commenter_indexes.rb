class AddCommenterIndexes < ActiveRecord::Migration
  def change
    add_index :commenters, :email, :unique => true
    add_index :commenters, :username, :username => true
    add_index :commenters, :name
  end
end