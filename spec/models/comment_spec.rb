# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text(4000)
#  forum_id   :integer          not null
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
      (ModelHelper.all_status - Comment.valid_status).each do |status|
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
end
