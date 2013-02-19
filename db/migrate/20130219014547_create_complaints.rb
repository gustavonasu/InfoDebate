class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.integer :comment_id, :presence => true
      t.string :body, :presence => true, :limit => 4000
      t.integer :status, :presence => true
      t.integer :user_id, :presence => true

      t.timestamps
    end
    add_index :complaints, :comment_id
    add_index :complaints, :user_id
  end
end
