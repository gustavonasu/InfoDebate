class CreateForumThreads < ActiveRecord::Migration
  def change
    create_table :forum_threads do |t|
      t.string :name, :null => false, :limit => 100
      t.string :description
      t.string :url, :limit => 500
      t.integer :status, :null => false
      t.integer :content_id

      t.timestamps
    end
  end
end
