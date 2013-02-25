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
      threads << FactoryGirl.create(:forum_thread, :forum => forum)
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
    
    it "should have active status by default" do
      thread = create_thread(@attrs)
      thread.should be_active
    end
    
    it "thread should be inactive when forum is inactive using association create method" do
      forum = FactoryGirl.create(:forum)
      forum.inactive!
      thread = forum.threads.create(@attrs)
      thread.should be_inactive
    end
    
    it "thread should be inactive when forum is inactive using new method" do
      forum = FactoryGirl.create(:forum)
      forum.inactive!
      thread = ForumThread.new(@attrs)
      thread.forum = forum
      thread.should be_inactive
    end
  end
  
  describe "Model Status" do
    before do
      @thread = FactoryGirl.create(:full_forum_thread)
    end
    
    it_should_behave_like "define status methods" do
      subject { @thread }
    end
      
    context "Status Trasition" do
      it_should_behave_like "status validation", ForumThread, :full_forum_thread
    end
      
    context "Cascades validations" do
      before do
        comment = FactoryGirl.create(:comment, :with_user, :thread => @thread)
        comment.complaints << FactoryGirl.create(:complaint, :with_user, :comment => comment)
        @thread.comments << comment
        @thread.save!
      end
      
      it "should cascade deletion to comment using destroy" do
        @thread.destroy
        assert_delete_cascade(@thread)
      end
    
      it "should cascade deletion to comment using delete" do
        @thread.delete!
        assert_delete_cascade(@thread) 
      end
    
      it "should cascade reject to comment using inactive" do
        @thread.inactive!
        ForumThread.unscoped.find(@thread.id).should be_inactive
        @thread.comments.each do |c|
          Comment.unscoped.find(c.id).should be_rejected
        end
      end
    
      def assert_delete_cascade(thread)
        ForumThread.unscoped.find(thread.id).should be_deleted
        thread.comments.each do |comment|
          Comment.unscoped.find(comment.id).should be_deleted
          comment.complaints.each do |complaint|
            Complaint.unscoped.find(complaint.id).should be_deleted
          end
        end
      end
    end
    
    describe "Delete Thread" do
      it_should_behave_like "destroy ModelStatus instance" do
        subject { @thread }
        let(:type) { ForumThread }
      end
    end
    
    describe "Target status constraints" do
      it "target_status should return deleted when forum is not active" do
        thread = FactoryGirl.create(:full_forum_thread)
        thread.forum.inactive!
        thread.target_status.should =~ [:deleted]
      end
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
    
    it_should_behave_like "Standard Search By Name" do
      subject { @thread }
      let(:type) { ForumThread }
      let(:num_instances) { @num_threads }
    end
    
    it_should_behave_like "Standard Search" do
      subject { @thread }
      let(:type) { ForumThread }
      let(:num_instances) { @num_threads }
    end
    
    context "Special search cases" do
      before do
        @another_forum = FactoryGirl.create(:forum)
        @another_thread = FactoryGirl.create(:forum_thread, :forum => @another_forum)
      end
      
      it "should return correctly searching by forum" do
        results = ForumThread.search({:forum_id => @another_forum.id})
        results.should eq([@another_thread])
      end
    end
  end
end
