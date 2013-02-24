# == Schema Information
#
# Table name: complaints
#
#  id         :integer          not null, primary key
#  comment_id :integer
#  body       :string(4000)
#  status     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Complaint do
  include ModelHelper

  before do
    @attrs = {:body => "Complaint text"}
    thread = FactoryGirl.create(:forum_thread, :with_forum)
    @user = FactoryGirl.create(:user)
    @comment = FactoryGirl.create(:comment, :thread => thread, :user => @user)
  end
  
  def create_complaint(attrs = @attrs, comment = @comment, user = @user)
    complaint = Complaint.create(attrs)
    complaint.comment = comment
    complaint.user = user
    complaint.save
    complaint
  end

  def create_complaints(total)
    complaints = []
    total.times do
      thread = FactoryGirl.create(:forum_thread, :with_forum)
      user = FactoryGirl.create(:user)
      comment = FactoryGirl.create(:comment, :thread => thread, :user => user)
      complaints << FactoryGirl.create(:complaint, :body => FactoryGirl.generate(:text_complaint),
                                                   :comment => comment, :user => user)
    end
    complaints
  end

  
  describe "Object creation" do
    
    it "should create a new instance given right attributes" do
      complaint = create_complaint
      complaint.should be_valid
    end
    
    it "should not create new instance given blank body attribute" do
      complaint = create_complaint({:body => ""})
      complaint.should_not be_valid
    end
  end

  describe "Status validation" do
    before do
      @complaint = create_complaint
    end
    
    context "Valid status" do
      
      it_should_behave_like "define status methods" do
        subject { @complaint }
      end
      
      Complaint.target_status.each do |status|
        it_should_behave_like "valid #{status} status validation" do
          subject { @complaint }
        end
        
        it_should_behave_like "valid #{status} status validation with persistence" do
          subject { @complaint }
        end
      end
    end
    
    context "Untarget status" do
      Complaint.un_target_status.each do |status|
        it_should_behave_like "un-target #{status} status validation" do
          subject { @complaint }
        end
        
        it_should_behave_like "un-target #{status} status validation with persistence" do
          subject { @complaint }
        end
      end
    end
    
    context "Invalid status" do
      Complaint.invalid_status.each do |status|
        it_should_behave_like "invalid #{status} status validation" do
          subject { @complaint }
        end
        
        it_should_behave_like "invalid #{status} status validation with persistence" do
          subject { @complaint }
        end
      end
    end
    
    context "Terminal status" do
      Complaint.terminal_status.each do |status|
        it_should_behave_like "terminal #{status} status validation" do
          subject { @complaint }
        end
        
        it_should_behave_like "terminal #{status} status validation with persistence" do
          subject { @complaint }
        end
      end
    end
  end

  describe "Object deletion" do
    before do
      @complaint = create_complaint
      @complaint.save!
    end
    
    it_should_behave_like "destroy ModelStatus instance" do
      subject { @complaint }
      let(:type) { Complaint }
    end
  end
  
  describe "Customized search" do
    before do
      @num_complaints = 30
      @complaints = create_complaints(@num_complaints)
      @complaint = @complaints[-1]
    end
    
    it_should_behave_like "Standard Search" do
      subject { @complaint }
      let(:type) { Complaint }
      let(:num_instances) { @num_complaints }
    end
  end

end
