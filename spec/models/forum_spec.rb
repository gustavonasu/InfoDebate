require 'spec_helper'

describe Forum do

  before do
    @attrs = { 
      :name => "Sample Forum",
      :description => "Forum Description"
    }
  end

  it "should create a valid new instance given right attributes" do
    forum = Forum.new(@attrs)
    forum.should be_valid
    forum.valid?
    forum.actived?.should be_true
  end
  
  it "should not create a valid new instance with blank name" do
    forum = Forum.new(@attrs.merge(:name => ""))
    forum.should_not be_valid
  end
  
  it "should create a new instance with blank description" do
    forum = Forum.new(@attrs.merge(:description => ""))
    forum.should be_valid
  end
  
  context "state change" do
    
    before do
      @forum = Forum.new(@attrs)
    end
    
    it "should inactive a forum instance" do
      @forum.inactive
      @forum.inactived?.should be_true
      @forum.actived?.should be_false
      @forum.deleted?.should be_false
    end
    
    it "should active a forum instance" do
      @forum.active
      @forum.actived?.should be_true
      @forum.inactived?.should be_false
      @forum.deleted?.should be_false
    end
    
    it "should active a forum instance" do
      @forum.delete
      @forum.deleted?.should be_true
      @forum.actived?.should be_false
      @forum.inactived?.should be_false
    end
  end
end