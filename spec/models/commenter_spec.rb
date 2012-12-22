# == Schema Information
#
# Table name: commenters
#
#  id                 :integer          not null, primary key
#  name               :string(100)      not null
#  username           :string(30)       not null
#  email              :string(255)      not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe Commenter do
  before do
    @attrs = { 
      :name => "Sample Commenter",
      :username => "sample_commenter",
      :email => "sample_commenter@infodebate.com",
      :password => "secret",
      :password_confirmation => "secret"
    }
  end
  
  it "should create a new instance given right attributes" do
    commenter = Commenter.new(@attrs)
    commenter.should be_valid
  end
  
  it "should update commenter without password" do
    new_name = "New Commenter"
    Commenter.create(@attrs)
    commenter = Commenter.first
    commenter.update_attributes(:name => new_name, :email => "new_commenter@infodebate.com")
    commenter.should be_valid
  end
  
  context "name attribute validations" do
    it "should create a new instance with 100 chars on name attr" do
      commenter = Commenter.new(@attrs.merge(:name => "a"*100))
      commenter.should be_valid
    end
  
    it "name should not be blank" do
      commenter = Commenter.new(@attrs.merge(:name => ""))
      commenter.should_not be_valid
    end
  
    it "name should not be greater than 100" do
      commenter = Commenter.new(@attrs.merge(:name => "a"*101))
      commenter.should_not be_valid
    end
  end
  
  
  context "username attribute validations" do
    it "username should not be blank" do
      commenter = Commenter.new(@attrs.merge(:username => ""))
      commenter.should_not be_valid
    end
  
    it "username should not be lesser than 3" do
      commenter = Commenter.new(@attrs.merge(:username => "a"*2))
      commenter.should_not be_valid
    end
  
    it "username should not be greater than 30" do
      commenter = Commenter.new(@attrs.merge(:username => "a"*31))
      commenter.should_not be_valid
    end
  
    it "username should be unique" do
      Commenter.create!(@attrs)
      commenter = Commenter.new(@attrs.merge(:email => "new_email@example.com"))
      commenter.should_not be_valid
      commenter.errors["username"].size.should > 0
    end
    
    it "username should be readonly" do
      commenter = Commenter.create!(@attrs)
      old_username = commenter.username
      commenter.username = "new_username"
      commenter.save
      commenter.reload
      commenter.username.should eq(old_username)
    end
  end
  
  
  context "email attribute validations" do
    it "email should not be blank" do
      commenter = Commenter.new(@attrs.merge(:email => ""))
      commenter.should_not be_valid
    end
  
    it "email should have correct format" do
      commenter = Commenter.new(@attrs.merge(:email => "test"))
      commenter.should_not be_valid
      commenter = Commenter.new(@attrs.merge(:email => "test@example"))
      commenter.should_not be_valid
      commenter = Commenter.new(@attrs.merge(:email => "test@example.com"))
      commenter.should be_valid
    end
  
    it "email should be unique" do
      Commenter.create!(@attrs)
      commenter = Commenter.new(@attrs.merge(:username => "new_username"))
      commenter.should_not be_valid
      commenter.errors["email"].size.should > 0
    end
  end
  
  
  context "password attribute validations" do
    it "password should not be blank" do
      commenter = Commenter.new(@attrs.merge(:password => ""))
      commenter.should_not be_valid
    end
    
    it "password and password_confirmation should be equal" do
      commenter = Commenter.new(@attrs.merge(:password => "pass",
                                             :password_confirmation => "pass1"))
      commenter.should_not be_valid
    end
    
    it "password should not be lesser than 6" do
      pass = "a"*5
      commenter = Commenter.new(@attrs.merge(:password => pass,
                                             :password_confirmation => pass))
      commenter.should_not be_valid
    end
  
    it "password should not be greater than 40" do
      pass = "a"*41
      commenter = Commenter.new(@attrs.merge(:password => pass,
                                             :password_confirmation => pass))
      commenter.should_not be_valid
    end
    
    it "should not update password without password_confirmation" do
      Commenter.create!(@attrs)
      commenter = Commenter.first
      commenter.update_attributes(:password => "new_pass", :password_confirmation => "")
      commenter.errors['password'].length.should be > 0
      commenter.should_not be_valid
    end
    
    it "should update password" do
      Commenter.create!(@attrs)
      commenter = Commenter.first
      pass = "new_pass"
      commenter.update_attributes(:password => pass, :password_confirmation => pass)
      commenter.should be_valid
    end
  end
  
  context "authentication" do
    it "should authenticate with right password" do
      pass = "right_password"
      commenter = Commenter.create(@attrs.merge(:password => pass,
                                                :password_confirmation => pass))
      Commenter.authenticate(commenter.username, pass).should eq commenter
    end
    
    it "should not authenticate with wrong password" do
      pass = "right_password"
      commenter = Commenter.create(@attrs.merge(:password => pass,
                                                :password_confirmation => pass))
      Commenter.authenticate(commenter.username, "wrong_pass").should_not eq commenter
    end
  end
end
