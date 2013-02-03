class AddForumFkToForumThread < ActiveRecord::Migration
  def up
    add_column :forum_threads, :forum_id, :integer
    
    ForumThread.reset_column_information
    
    forum = Forum.first
    ForumThread.all.each do |thread|
      thread.forum = forum
      thread.save!
    end
    
    change_column :forum_threads, :forum_id, :integer, :null => false
    add_index :forum_threads, :forum_id
  end
  
  def down
    remove_index :forum_threads, :forum_id
    remove_column :forum_threads, :forum_id
  end
end
