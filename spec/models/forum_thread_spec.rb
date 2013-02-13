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
  include StandardSearchHelper
  
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
  
  def create_threads(total, forum)
    threads = []
    total.times do |n|
      threads << FactoryGirl.create(:forum_thread,
                                    :name => FactoryGirl.generate(:thread_name),
                                    :description => FactoryGirl.generate(:thread_name),
                                    :forum => forum)
    end
    threads
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
        @threads = create_threads(10, @forum)
        @another_forum = FactoryGirl.create(:forum)
        @another_threads = create_threads(10, @another_forum)
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
  
  describe "Customized search" do
    before do
      @forum = FactoryGirl.create(:forum)
      @num_threads = 30
      @threads = create_threads(@num_threads, @forum)
      @thread = @threads[-1]
    end
    
    it_should_behave_like "Standard Search" do
      subject { @thread }
      let(:type) { ForumThread }
      let(:num_instances) { @num_threads }
    end
  end
end
