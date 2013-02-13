# == Schema Information
#
# Table name: forums
#
#  id          :integer          not null, primary key
#  name        :string(100)      not null
#  description :string(255)
#  status      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Forum do
  include ModelHelper
  
  before do
    @attrs = { 
      :name => "Sample Forum",
      :description => "Forum Description"
    }
  end
  
  describe "Object creation" do
    it "should create a valid new instance given right attributes" do
      forum = Forum.new(@attrs)
      forum.should be_valid
      forum.active?.should be_true
    end
  
    it "should not create a valid new instance with blank name" do
      forum = Forum.new(@attrs.merge(:name => ""))
      forum.should_not be_valid
      forum.errors[:name].should cannot_be_blank
    end
  
    it "should create a new instance with blank description" do
      forum = Forum.new(@attrs.merge(:description => ""))
      forum.should be_valid
    end
  end
  
  describe "Status validation" do
    before do
      @forum = Forum.create(@attrs)
    end
    
    context "Valid status" do
      Forum.valid_status.each do |status|
        it_should_behave_like "valid #{status} status validation" do
          subject { @forum }
        end
      end
    end
    
    context "Invalid status" do
      (ModelHelper.all_status - Forum.valid_status).each do |status|
        it_should_behave_like "invalid #{status} status validation" do
          subject { @forum }
        end
      end
    end
  end
  
  describe "Object deletion" do
    before do
      @forum = Forum.create!(@attrs)
    end
    
    it_should_behave_like "destroy ModelStatus instance" do
      subject { @forum }
      let(:type) { Forum }
    end
  end
  
  describe "Threads relationship" do
    before do
      @forum = Forum.create!(@attrs)
      @threds_attrs = { :name => "Sample Thread",
                        :description => "Thread Description",
                        :url => "http://infodebate.com/article/1",
                        :content_id => 2}
    end
    
    context "Thread creation" do
      it "should create thread instance" do
        thread = @forum.threads.create(@threds_attrs)
        thread.id.should_not be_nil
        thread.active?.should be_true
        thread.forum.should eq(@forum)
      end
    end
    
    context "Thread searches" do
      before do
        @threads = []
        10.times do |n|
          @threads << FactoryGirl.create( :forum_thread,
                                          :forum => @forum,
                                          :content_id => n,
                                          :url => FactoryGirl.generate(:content_url))
        end
        @thread = @threads[-1]
      end
      
      it "should return all threads" do
        @forum.threads.all.should eq(@threads)
      end
      
      it "should search by forum_id" do
        @forum.threads.find_all_by_forum_id(@forum).should eq(@threads)
      end
      
      it "should search by content_id" do
        @forum.threads.find_by_content_id(@thread.content_id).should eq(@thread)
      end
      
      it "should search by url" do
        @forum.threads.find_by_url(@thread.url).should eq(@thread)
      end
    end
  end
  
  describe "Customized search" do
    before do
      @numOfForums = 30
      @forums = []
      @numOfForums.times do |i|
        @forums << FactoryGirl.create(:forum,
                                :name => FactoryGirl.generate(:forum_name))
      end
    end
    
    context "searchByName" do
      it "should limit pagination" do
        limit = 5
        results = Forum.search_by_name("", limit)
        results.size.should eq(limit)
      end
      
      it "should return correctly" do
        forum = @forums[-1]
        results = Forum.search_by_name(forum.name)
        results.should include(forum)
      end
    end
  end
end
