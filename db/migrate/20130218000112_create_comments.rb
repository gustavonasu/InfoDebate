class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, :limit => 4000
      t.integer :thread_id, :null => false
      t.integer :user_id, :null => false
      t.integer :status, :null => false
      t.integer :dislike, :default => 0
      t.integer :like, :default => 0
      t.integer :parent_id

      t.timestamps
    end
    add_index :comments, :thread_id
    add_index :comments, :user_id
    add_index :comments, :parent_id
  end
end
