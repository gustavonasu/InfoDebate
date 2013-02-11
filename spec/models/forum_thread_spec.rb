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
  
  def create_thread(attrs)
    thread = ForumThread.new(attrs)
    thread.forum = FactoryGirl.create(:forum)
    thread
  end
  
  describe "Object creation" do
    it "should create a valid new instance given right attributes" do
      thread = create_thread(@attrs)
      thread.should be_valid
      thread.active?.should be_true
    end
  
    it "should not create a valid new instance with blank name" do
      thread = create_thread(@attrs.merge(:name => ""))
      thread.should_not be_valid
      thread.errors[:name].should cannot_be_blank
    end
  
    it "should create a valid new instance with blank description" do
      thread = create_thread(@attrs.merge(:description => ""))
      thread.should be_valid
    end
  
    it "should create a valid new instance with blank url" do
      thread = create_thread(@attrs.merge(:url => ""))
      thread.should be_valid
    end
  
    it "should create a valid new instance with nil content_id" do
      thread = create_thread(@attrs.merge(:content_id => nil))
      thread.should be_valid
    end
    
    it "should not create a valid new instance with forum nil" do
      thread = ForumThread.new(@attrs)
      thread.should_not be_valid
      thread.errors[:forum_id].should cannot_be_blank
    end
  end
  
  describe "Status validation" do
    before do
      @thread = ForumThread.new(@attrs)
      @thread.forum = FactoryGirl.create(:forum)
    end
    
    context "Valid status" do
      ForumThread.valid_status.each do |status|
        it_should_behave_like "valid #{status} status validation" do
          subject { @thread }
        end
      end
    end
    
    context "Invalid status" do
      (ModelHelper.all_status - ForumThread.valid_status).each do |status|
        it_should_behave_like "invalid #{status} status validation" do
          subject { @thread }
        end
      end
    end
  end
  
  describe "Object deletion" do
    before do
      @thread = create_thread(@attrs)
      @thread.save()
    end
    
    it_should_behave_like "destroy ModelStatus instance" do
      subject { @thread }
      let(:type) { ForumThread }
    end
  end
  
  describe "Search" do
    context "Forum relationship" do
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
end
