# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(100)      not null
#  username           :string(30)       not null
#  email              :string(255)      not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  status             :integer
#

require 'spec_helper'

describe User do
  include ModelHelper
    
  before do
    @attrs = { 
      :name => "Sample User",
      :username => "sample_user",
      :email => "sample_user@infodebate.com",
      :password => "secret",
      :password_confirmation => "secret"
    }
  end
  
  describe "Object creation" do
    
    it "should create a new instance given right attributes" do
      user = User.new(@attrs)
      user.should be_valid
    end
  
    it "should update user without password" do
      new_name = "New User"
      User.create!(@attrs)
      user = User.first
      user.update_attributes(:name => new_name, :email => "new_user@infodebate.com")
      user.should be_valid
    end
  
    context "Name attribute validations" do
      it "should create a new instance with 100 chars on name attr" do
        user = User.new(@attrs.merge(:name => "a"*100))
        user.should be_valid
      end
      
      it "name should not be blank" do
        user = User.new(@attrs.merge(:name => ""))
        user.should_not be_valid
        user.errors[:name].should cannot_be_blank
      end
      
      it "name should not be greater than 100" do
        user = User.new(@attrs.merge(:name => "a"*101))
        user.should_not be_valid
        user.errors[:name].should too_long
      end
    end
    
    context "Username attribute validations" do
      it "username should not be blank" do
        user = User.new(@attrs.merge(:username => ""))
        user.should_not be_valid
        user.errors[:username].should cannot_be_blank
      end
  
      it "username should not be lesser than 3" do
        user = User.new(@attrs.merge(:username => "a"*2))
        user.should_not be_valid
        user.errors[:username].should too_short
      end
  
      it "username should not be greater than 30" do
        user = User.new(@attrs.merge(:username => "a"*31))
        user.should_not be_valid
        user.errors[:username].should too_long
      end
  
      it "username should be unique" do
        User.create!(@attrs)
        user = User.new(@attrs.merge(:email => "new_email@example.com"))
        user.should_not be_valid
        user.errors[:username].should be_unique
      end
    
      it "username should be readonly" do
        user = User.create!(@attrs)
        old_username = user.username
        user.username = "new_username"
        user.save
        user.reload
        user.username.should eq(old_username)
      end
    end
    
    context "Email attribute validations" do
      it "email should not be blank" do
        user = User.new(@attrs.merge(:email => ""))
        user.should_not be_valid
      end
      
      it "email should have correct format" do
        user = User.new(@attrs.merge(:email => "test"))
        user.should_not be_valid
        user.errors[:email].should invalid_email
        user = User.new(@attrs.merge(:email => "test@example"))
        user.should_not be_valid
        user.errors[:email].should invalid_email
        user = User.new(@attrs.merge(:email => "test@example.com"))
        user.should be_valid
      end
      
      it "email should be unique" do
        User.create!(@attrs)
        user = User.new(@attrs.merge(:username => "new_username"))
        user.should_not be_valid
        user.errors[:email].should be_unique
      end
    end
    
    context "Password attribute validations" do
      it "password should not be blank" do
        user = User.new(@attrs.merge(:password => ""))
        user.should_not be_valid
        user.errors[:password].should too_short
      end
      
      it "password and password_confirmation should be equal" do
        user = User.new(@attrs.merge(:password => "pass",
                                               :password_confirmation => "pass1"))
        user.should_not be_valid
        user.errors[:password].should not_match_confirmation
      end
      
      it "password should not be lesser than 6" do
        pass = "a"*5
        user = User.new(@attrs.merge(:password => pass,
                                               :password_confirmation => pass))
        user.should_not be_valid
        user.errors[:password].should too_short
      end
      
      it "password should not be greater than 40" do
        pass = "a"*41
        user = User.new(@attrs.merge(:password => pass,
                                               :password_confirmation => pass))
        user.should_not be_valid
        user.errors[:password].should too_long
      end
      
      it "should not update password without password_confirmation" do
        User.create!(@attrs)
        user = User.first
        user.update_attributes(:password => "new_pass", :password_confirmation => "")
        user.should_not be_valid
        user.errors[:password].should not_match_confirmation
      end
      
      it "should update password" do
        User.create!(@attrs)
        user = User.first
        pass = "new_pass"
        user.update_attributes(:password => pass, :password_confirmation => pass)
        user.should be_valid
      end
      
      it "should not update pass without confirmation" do
        pass = "secret123"
        User.create!(@attrs.merge(:password => pass, :password_confirmation => pass))
        user = User.first
        user.update_attributes(:password => "newpassword")
        user.should_not be_valid
        user.reload
        user.has_password(pass).should be_true
      end
    end
  end
  
  describe "Status validation" do
    before do
      @user = User.create!(@attrs)
    end
    
    context "Valid status" do
      User.valid_status.each do |status|
        it_should_behave_like "valid #{status} status validation" do
          subject { @user }
        end
        
        it_should_behave_like "valid #{status} status validation with persistence" do
          subject { @user }
        end
      end
    end
    
    context "Invalid status" do
      (ModelHelper.all_status - User.valid_status).each do |status|
        it_should_behave_like "invalid #{status} status validation" do
          subject { @user }
        end
        
        it_should_behave_like "invalid #{status} status validation with persistence" do
          subject { @user }
        end
      end
    end
  end
  
  describe "Object deletion" do
    before do
      @user = User.create!(@attrs)
    end
    
    it_should_behave_like "destroy ModelStatus instance" do
      subject { @user }
      let(:type) { User }
    end
  end
  
  describe "Customized search" do
     before do
       @num_users = 30
       @users = []
       @num_users.times do
         @users << FactoryGirl.create(:user, :name => FactoryGirl.generate(:name),
                                             :username => FactoryGirl.generate(:username),
                                             :email => FactoryGirl.generate(:email))
       end
       @user = @users[-1]
     end

     it_should_behave_like "Standard Search By Name" do
       subject { @user }
       let(:type) { User }
       let(:num_instances) { @num_users }
     end

     it_should_behave_like "Standard Search" do
       subject { @user }
       let(:type) { User }
       let(:num_instances) { @num_users }
     end
   end
  
  describe "Authentication" do
    it "should authenticate with right password" do
      pass = "right_password"
      user = User.create(@attrs.merge(:password => pass,
                                                :password_confirmation => pass))
      User.authenticate(user.username, pass).should eq user
    end
    
    it "should not authenticate with wrong password" do
      pass = "right_password"
      user = User.create(@attrs.merge(:password => pass,
                                                :password_confirmation => pass))
      User.authenticate(user.username, "wrong_pass").should_not eq user
    end
  end
end
