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
    @user = FactoryGirl.create(:user)
    @comment = FactoryGirl.create(:comment, :with_thread, :user => @user)
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
      complaints << FactoryGirl.create(:complaint, :with_comment, :with_user)
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

  describe "Model Status" do
    before do
      @complaint = FactoryGirl.create(:full_complaint)
    end
    
    it_should_behave_like "define status methods" do
      subject { @user }
    end
    
    context "Status Trasition" do
      it_should_behave_like "status validation", Complaint, :full_complaint
    end
    
    describe "Object deletion" do
      it_should_behave_like "destroy ModelStatus instance" do
        subject { @complaint }
        let(:type) { Complaint }
      end
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
