class ChangeNameLimitToForumThreads < ActiveRecord::Migration
  def up
    change_column :forum_threads, :name, :string, :null => false, :limit => 255
  end
  
  def down
    change_column :forum_threads, :name, :string, :null => false, :limit => 100
  end
end
