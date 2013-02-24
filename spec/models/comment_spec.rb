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
  
  def create_comments(total)
    comments = []
    total.times do
      thread = FactoryGirl.create(:forum_thread, :with_forum)
      user = FactoryGirl.create(:user)
      comments << FactoryGirl.create(:comment, :body => FactoryGirl.generate(:text_comment),
                                               :thread => thread, :user => user)
    end
    comments
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
  end
  
  describe "Status validation" do
    before do
      @comment = create_comment
    end
    
    context "Valid status" do
      before do
        @comment.save
        @comment.complaints << FactoryGirl.create(:complaint,
                                                  :comment => @comment,
                                                  :user => @user)
        @comment.save!
      end
      
      it_should_behave_like "define status methods" do
        subject { @comment }
      end
      
      Comment.target_status.each do |status|
        it_should_behave_like "valid #{status} status validation" do
          subject { @comment }
        end
        
        it_should_behave_like "valid #{status} status validation with persistence" do
          subject { @comment }
        end
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
    
    context "Untarget status" do
      Comment.un_target_status.each do |status|
        it_should_behave_like "un-target #{status} status validation" do
          subject { @comment }
        end
        
        it_should_behave_like "un-target #{status} status validation with persistence" do
          subject { @comment }
        end
      end
    end
    
    context "Invalid status" do
      Comment.invalid_status.each do |status|
        it_should_behave_like "invalid #{status} status validation" do
          subject { @comment }
        end
        
        it_should_behave_like "invalid #{status} status validation with persistence" do
          subject { @comment }
        end
      end
    end
    
    context "Terminal status" do
      Comment.terminal_status.each do |status|
        it_should_behave_like "terminal #{status} status validation" do
          subject { @comment }
        end
        
        it_should_behave_like "terminal #{status} status validation with persistence" do
          subject { @comment }
        end
      end
    end
  end
  
  describe "Object deletion" do
    before do
      @comment = create_comment
      @comment.save!
    end
    
    it_should_behave_like "destroy ModelStatus instance" do
      subject { @comment }
      let(:type) { Comment }
    end
  end
  
  describe "Customized search" do
    before do
      @num_comments = 30
      @comments = create_comments(@num_comments)
      @comment = @comments[-1]
    end
    
    it_should_behave_like "Standard Search" do
      subject { @comment }
      let(:type) { Comment }
      let(:num_instances) { @num_comments }
    end
  end
end
