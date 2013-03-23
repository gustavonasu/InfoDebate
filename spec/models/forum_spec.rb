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
  include StandardSearchHelper
  
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
  
  describe "Model Status" do
    before do
      @forum = Forum.create(@attrs)
      @forum.threads << FactoryGirl.create(:forum_thread, :forum => @forum)
      @forum.save!
    end
    
    it_should_behave_like "define status methods" do
      subject { @forum }
    end
    
    context "Status Trasition" do
      it_should_behave_like "status validation", Forum do
        subject { @forum }
      end
    end
    
    context "Cascades validations" do
      
      it "should cascade inactive action to threads" do
        @forum.inactive!
        @forum.reload.should be_inactive
        @forum.threads.each do |t|
          t.reload.should be_inactive
        end
      end
      
      it "should cascade deletion to forum_thread using destroy" do
        @forum.destroy
        assert_delete_cascade(@forum)
      end

      it "should cascade deletion to forum_thread using delete" do
        @forum.delete!
        assert_delete_cascade(@forum)
      end

      def assert_delete_cascade(forum)
        Forum.unscoped.find(forum.id).should be_deleted
        forum.threads.each do |t|
          ForumThread.unscoped.find(t.id).should be_deleted
        end
      end
    end
    
    context "Delete forum" do
      it_should_behave_like "destroy ModelStatus instance" do
        subject { @forum }
        let(:type) { Forum }
      end
    end
  end
  
  describe "Status Search" do
    before do
      @num_forums = 30
      @forums = FactoryGirl.create_list(:forum, @num_forums)
    end
    
    it "default search should ignored deleted forums" do
      forum = @forums[-1]
      forum.delete
      forum.save
      Forum.all.length.should eq(@num_forums - 1)
    end
  end
  
  describe "Customized search" do
    before do
      @num_forums = 30
      @forums = FactoryGirl.create_list(:forum, @num_forums)
      @forum = @forums[-1]
    end
    
    it_should_behave_like "Standard Search By Name" do
      subject { @forum }
      let(:type) { Forum }
      let(:num_instances) { @num_forums }
    end
    
    it_should_behave_like "Standard Search" do
      subject { @forum }
      let(:type) { Forum }
      let(:num_instances) { @num_forums }
    end
    
    it "should be ordered by name" do
      limit = 5
      result = Forum.search({:term => "%"}, 1, limit)
      @forums.sort_by { |f| f.name }.first(limit).each_with_index do |f, index|
        f.should eq(result[index])
      end
    end
  end
end
