# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :string(4000)
#  thread_id  :integer          not null
#  user_id    :integer          not null
#  status     :integer          not null
#  dislike    :integer          default(0)
#  like       :integer          default(0)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Comment do
  include ModelHelper

  before do
    @attrs = { 
      :body => "Comment"
    }
    @thread = FactoryGirl.create(:forum_thread, :with_forum)
    @user = FactoryGirl.create(:user)
  end
  
  def create_comment(attrs = @attrs, thread = @thread, user = @user)
    comment = Comment.new(attrs)
    comment.thread = thread
    comment.user = user
    comment
  end
  
  describe "Object creation" do
    it "should create a new instance given right attributes" do
      comment = create_comment
      comment.should be_valid
    end
    
    it "should not create new instance given blank body attribute" do
      comment = create_comment({:body => ""})
      comment.should_not be_valid
    end
    
    it "complaint should not be created when user is not active" do
      user = FactoryGirl.create(:user)
      user.inactive!
      comment = FactoryGirl.build(:comment, :with_thread)
      comment.user = user
      expect { comment.save! }.to raise_error(CreationModelError)
    end
    
    it "complaint should not be created when user is not active" do
      thread = FactoryGirl.create(:full_forum_thread)
      thread.inactive!
      comment = FactoryGirl.build(:comment, :with_user)
      comment.thread = thread
      expect { comment.save! }.to raise_error(CreationModelError)
    end
  end
  
  describe "Model Status" do
    before do
      @comment = FactoryGirl.create(:full_comment)
    end
    
    it_should_behave_like "define status methods" do
      subject { @comment }
    end
    
    context "Status Trasition" do
      it_should_behave_like "status validation", Comment do
        subject { @comment }
      end
    end
    
    context "Cascades validations" do
      before do
        @comment.complaints << FactoryGirl.create(:complaint, :with_user, :comment => @comment)
        @comment.save!
      end
      
      it "should cascade deletion to comment using destroy" do
        @comment.destroy
        assert_delete_cascade(@comment)
      end
      
      it "should cascade deletion to comment using delete" do
        @comment.delete!
        assert_delete_cascade(@comment)
      end
      
      def assert_delete_cascade(comment)
        Comment.unscoped.find(comment.id).should be_deleted
        comment.complaints.each do |c|
          Complaint.unscoped.find(c.id).should be_deleted
        end
      end
    end
    
    context "Delete comment" do
      it_should_behave_like "destroy ModelStatus instance" do
        subject { @comment }
        let(:type) { Comment }
      end
    end
    
    describe "Target status constraints" do
      it "target_status should return deleted and spam when user is not active" do
        comment = FactoryGirl.create(:full_comment)
        comment.user.inactive!
        comment.target_status.should =~ [:deleted, :spam]
      end
      
      it "target_status should return deleted and spam when thread is not active" do
        comment = FactoryGirl.create(:full_comment)
        comment.thread.inactive!
        comment.target_status.should =~ [:deleted, :spam]
      end
    end
  end
  
  describe "Customized search" do
    before do
      @num_comments = 30
      @comments = FactoryGirl.create_list(:full_comment, @num_comments)
      @comment = @comments[-1]
    end
    
    it_should_behave_like "Standard Search" do
      subject { @comment }
      let(:type) { Comment }
      let(:num_instances) { @num_comments }
    end
  end
  
  describe "Recursive association" do
    before do
      @comment = FactoryGirl.create(:full_comment)
    end
    
    it "should create child with same user and thread" do
      body = "children body"
      @comment.children.create(:body => body)
      child = @comment.children[0]
      child.should be_valid
      child.body.should eq(body)
      child.user.should eq(@comment.user)
      child.thread.should eq(@comment.thread)
      child.parent.should eq(@comment)
    end
  end
end
