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
  
  describe "Forum creation" do
    it "should create a valid new instance given right attributes" do
      forum = Forum.new(@attrs)
      forum.should be_valid
      forum.active?.should be_true
    end
  
    it "should not create a valid new instance with blank name" do
      forum = Forum.new(@attrs.merge(:name => ""))
      forum.should_not be_valid
    end
  
    it "should create a new instance with blank description" do
      forum = Forum.new(@attrs.merge(:description => ""))
      forum.should be_valid
    end
  end
  
  describe "status validation" do
    before do
      @forum = Forum.create(@attrs)
    end
    
    context "valid status" do
      Forum.valid_status.each do |status|
        it_should_behave_like "valid #{status} status validation" do
          subject { @forum }
        end
      end
    end
    
    context "invalid status" do
      (ModelHelper.all_status - Forum.valid_status).each do |status|
        it_should_behave_like "invalid #{status} status validation" do
          subject { @forum }
        end
      end
    end
  end
  
  describe "threads relationship" do
    before do
      @forum = Forum.create!(@attrs)
      @threds_attrs = { :name => "Sample Thread",
                        :description => "Thread Description",
                        :url => "http://infodebate.com/article/1",
                        :content_id => 2}
    end
    
    context "thread creation" do
      it "should create thread instance" do
        thread = @forum.threads.create(@threds_attrs)
        thread.id.should_not be_nil
        thread.active?.should be_true
        thread.forum.should eq(@forum)
      end
    end
    
    context "thread searches" do
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
end
