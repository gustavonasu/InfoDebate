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
    @forum = FactoryGirl.create(:forum)
    @thread = FactoryGirl.create(:forum_thread, :forum => @forum)
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
      thread = FactoryGirl.create(:forum_thread, :forum => @forum)
      user = FactoryGirl.create(:user, :name => FactoryGirl.generate(:name),
                                       :username => FactoryGirl.generate(:username),
                                       :email => FactoryGirl.generate(:email))
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
      
      it_should_behave_like "define status methods" do
        subject { @comment }
      end
      
      Comment.valid_status.each do |status|
        it_should_behave_like "valid #{status} status validation" do
          subject { @comment }
        end
        
        it_should_behave_like "valid #{status} status validation with persistence" do
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
