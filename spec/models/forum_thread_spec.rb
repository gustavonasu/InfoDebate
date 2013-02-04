# == Schema Information
#
# Table name: forum_threads
#
#  id          :integer          not null, primary key
#  name        :string(100)      not null
#  description :string(255)
#  url         :string(500)
#  status      :integer          not null
#  content_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  forum_id    :integer          not null
#

require 'spec_helper'

describe ForumThread do
  include ModelHelper
  
  before do
    @attrs = { 
      :name => "Sample Thread",
      :description => "Thread Description",
      :url => "http://infodebate.com/article/1",
      :content_id => 2
    }
  end
  
  it "should create a valid new instance given right attributes" do
    thread = ForumThread.new(@attrs)
    thread.should be_valid
    thread.active?.should be_true
  end
  
  it "should not create a new instance with blank name" do
    thread = ForumThread.new(@attrs.merge(:name => ""))
    thread.should_not be_valid
  end
  
  it "should create a new instance with blank description" do
    thread = ForumThread.new(@attrs.merge(:description => ""))
    thread.should be_valid
  end
  
  it "should create a new instance with blank url" do
    thread = ForumThread.new(@attrs.merge(:url => ""))
    thread.should be_valid
  end
  
  it "should create a new instance with nil content_id" do
    thread = ForumThread.new(@attrs.merge(:content_id => nil))
    thread.should be_valid
  end
  
  describe "status validation" do
    before do
      @thread = ForumThread.new(@attrs)
      @thread.forum = FactoryGirl.create(:forum)
    end
    
    context "valid status" do
      ForumThread.valid_status.each do |status|
        it_should_behave_like "valid #{status} status validation" do
          subject { @thread }
        end
      end
    end
    
    context "invalid status" do
      (ModelHelper.all_status - ForumThread.valid_status).each do |status|
        it_should_behave_like "invalid #{status} status validation" do
          subject { @thread }
        end
      end
    end
  end
  
  context "forum relationship" do
    before do
      @forum = FactoryGirl.create(:forum)
      @threads = create_threads(@forum)
      @another_forum = FactoryGirl.create(:forum)
      @another_threads = create_threads(@another_forum)
    end
    
    def create_threads(forum)
      threads = []
      10.times do |n|
        threads << FactoryGirl.create(:forum_thread, :forum => forum)
      end
      threads
    end
    
    it "should search by forum" do
      ForumThread.find_all_by_forum_id(@forum).should eq(@threads)
      ForumThread.find_all_by_forum_id(@another_forum).should eq(@another_threads)
    end
    
    it "should return threads search by forum relationship" do
      @forum.threads.all.should eql(@threads)
      @another_forum.threads.all.should eql(@another_threads)
    end
  end
end
