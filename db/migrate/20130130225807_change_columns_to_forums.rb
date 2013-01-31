class ChangeColumnsToForums < ActiveRecord::Migration
  def up
    change_column :forums, :name, :string, :null => false, :limit => 100
    change_column :forums, :status, :integer, :null => false
  end
  
  def down
    change_column :forums, :name, :string, :null => true, :limit => 255
    change_column :forums, :status, :integer, :null => true
  end
end
