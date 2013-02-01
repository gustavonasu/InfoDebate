require 'spec_helper'

describe ForumThread do
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
  
  context "state change" do
    
    before do
      @thread = ForumThread.new(@attrs)
    end
    
    it "should inactive a forum instance" do
      @thread.inactive
      @thread.inactive?.should be_true
      @thread.active?.should be_false
      @thread.deleted?.should be_false
    end
    
    it "should active a forum instance" do
      @thread.active
      @thread.active?.should be_true
      @thread.inactive?.should be_false
      @thread.deleted?.should be_false
    end
    
    it "should delete a forum instance" do
      @thread.delete
      @thread.deleted?.should be_true
      @thread.active?.should be_false
      @thread.inactive?.should be_false
    end
    
    it "should not banned a forum instance" do
      expect { @thread.ban }.to raise_error(Infodebate::InvalidStatus)
    end
    
    it "should not pending a forum instance" do
      expect { @thread.pending }.to raise_error(Infodebate::InvalidStatus)
    end
  end
end
