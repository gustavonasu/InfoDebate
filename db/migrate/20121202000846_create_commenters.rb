class CreateCommenters < ActiveRecord::Migration
  def change
    create_table :commenters do |t|
      t.string :name, :null => false, :limit => 100
      t.string :username, :null => false, :limit => 30
      t.string :email, :null => false
      t.string :encrypted_password
      t.string :salt
      t.timestamps
    end
  end
end
