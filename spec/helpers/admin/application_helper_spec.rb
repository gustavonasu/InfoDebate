require 'spec_helper'

describe Admin::ApplicationHelper do
  
  describe "status_url" do
    before do
      @status = "active"
      @basepath = "/admin/forum_threads"
      @param = "teste=1"
      @another_status_param = "status=another"
    end
    
    it "should add status to path without query string" do
      set_request_path(@basepath)
      helper.status_url(@status).should be_valid_status_path(@status)
    end
    
    it "should add status to path with query string" do
      set_request_path("#{@basepath}?#{@param}")
      new_path = helper.status_url(@status)
      new_path.should be_valid_status_path(@status)
      new_path.should include(@param)
    end
    
    it "should add new status to path beginnig with status" do
      set_request_path("#{@basepath}?#{@another_status_param}&#{@param}")
      new_path = helper.status_url(@status)
      new_path.should be_valid_status_path(@status)
      new_path.should include(@param)
      new_path.should_not include(@another_status_param)
    end
    
    it "should add new status to path ending with status" do
      set_request_path("#{@basepath}?#{@param}&#{@another_status_param}")
      new_path = helper.status_url(@status)
      new_path.should be_valid_status_path(@status)
      new_path.should include(@param)
      new_path.should_not include(@another_status_param)
    end
    
    def set_request_path(path)
      controller.stub(:request).and_return mock('request', :fullpath => path)
    end
  end
  
  
  describe "generate_status_change_actions" do
    
    context "Forum model" do
      before do
        @forum = FactoryGirl.create(:forum)
        @delete_map = {:label => t(:delete, :scope => :status_action), :path => admin_forum_path(@forum), :type => "danger", 
                       :method => "delete", :confirmation_msg => t(:confirmation_msg)}
        @inactive_map = {:label => t(:inactive, :scope => :status_action), :type => "warning",
                         :path => change_status_admin_forum_path(@forum, :status_action => "inactive"), 
                         :confirmation_msg => t(:confirmation_msg)}
        @active_map = {:label => t(:active, :scope => :status_action), :type => "info",
                       :path => change_status_admin_forum_path(@forum, :status_action => "active")}
      end
    
      it "with forum active" do
        actions = helper.generate_status_change_actions(@forum, "forum")
        actions.should include(@delete_map)
        actions.should include(@inactive_map)
      end
      
      it "with forum inactive" do
        @forum.inactive!
        actions = helper.generate_status_change_actions(@forum, "forum")
        actions.should include(@delete_map)
        actions.should include(@active_map)
      end
   end
  end
end


RSpec::Matchers.define :be_valid_status_path do |status|
  match do |actual|
    actual.include?("status=#{status}").should be_true
    actual.count("?").should eq(1)
    actual.include?("?&").should be_false
    actual.include?("&?").should be_false
    actual.include?("&&").should be_false
    actual.ends_with?("&").should be_false
  end
end