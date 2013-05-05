require 'spec_helper'

describe Admin::ApplicationHelper do
  
  describe "status_url" do
    before do
      @status = "active"
      @basepath = "/admin/forum_threads"
      @param = "teste=1"
      @page_param = "page=2"
      @another_status_param = "status=another"
    end
    
    it "should add status to path without query string" do
      set_request_path(@basepath)
      helper.status_url(@status).should be_valid_status_path(@status)
    end
    
    it "should change status to path with status param" do
      set_request_path("#{@basepath}?#{@another_status_param}")
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
    
    it "should not include page param" do
      set_request_path("#{@basepath}?#{@param}&#{@page_param}&#{@another_status_param}")
      new_path = helper.status_url(@status)
      new_path.should be_valid_status_path(@status)
      new_path.should include(@param)
      new_path.should_not include(@page_param)
    end
    
    def set_request_path(path)
      controller.stub(:request).and_return mock('request', :fullpath => path)
    end
  end
  
  
  describe "generate_status_change_actions" do
    
    context "Forum model" do
      before do
        @forum = FactoryGirl.create(:forum)
        @delete_map = {:label => t(:delete, :scope => :status_action),
                       :path => change_status_admin_forum_path(@forum, :status_action => "delete"),
                       :type => "danger", :confirmation_msg => t(:confirmation_msg)}
        @inactive_map = {:label => t(:inactive, :scope => :status_action), :type => "warning",
                         :path => change_status_admin_forum_path(@forum, :status_action => "inactive"), 
                         :confirmation_msg => t(:confirmation_msg)}
        @active_map = {:label => t(:active, :scope => :status_action), :type => "info",
                       :path => change_status_admin_forum_path(@forum, :status_action => "active")}
        @status_maps = {:delete => @delete_map, :inactive => @inactive_map, :active => @active_map}
      end
    
      it "with forum active" do
        actions = helper.generate_status_change_actions(@forum, "forum")
        assert_generated_status_change_actions @status_maps, actions, :active
      end
      
      it "with forum inactive" do
        @forum.inactive!
        actions = helper.generate_status_change_actions(@forum, "forum")
        assert_generated_status_change_actions @status_maps, actions, :inactive
      end
    end
    
    context "User model" do
      before do
        @user = FactoryGirl.create(:user)
        @delete_map = {:label => t(:delete, :scope => :status_action), 
                       :path => change_status_admin_user_path(@user, :status_action => "delete"),
                       :type => "danger", :confirmation_msg => t(:confirmation_msg)}
        @inactive_map = {:label => t(:inactive, :scope => :status_action), :type => "warning",
                         :path => change_status_admin_user_path(@user, :status_action => "inactive"),
                         :confirmation_msg => t(:confirmation_msg)}
        @ban_map = {:label => t(:ban, :scope => :status_action), :type => "danger",
                    :path => change_status_admin_user_path(@user, :status_action => "ban"),
                    :confirmation_msg => t(:confirmation_msg)}
        @active_map = {:label => t(:active, :scope => :status_action), :type => "info",
                       :path => change_status_admin_user_path(@user, :status_action => "active")}
        @status_maps = {:delete => @delete_map, :inactive => @inactive_map, :active => @active_map,
                        :ban => @ban_map}
      end
    
      it "with user active" do
        actions = helper.generate_status_change_actions(@user, "user")
        assert_generated_status_change_actions @status_maps, actions, :active
      end
      
      it "with user inactive" do
        @user.inactive!
        actions = helper.generate_status_change_actions(@user, "user")
        assert_generated_status_change_actions @status_maps, actions, :inactive
      end
      
      it "with user pendig" do
        @user.send("write_attribute", "status", @user.find_status_value(:pending))
        actions = helper.generate_status_change_actions(@user, "user")
        assert_generated_status_change_actions @status_maps, actions, :pending
      end
    end
    
    context "Comment model with call_from param" do
      before do
        @call_from = "comment_list"
        @comment = FactoryGirl.create(:comment, :with_user, :with_thread)
        @approved_map = {:label => t(:approve, :scope => :status_action), :type => "info",
                         :path => change_status_admin_comment_path(@comment, :status_action => "approve",
                         :call_from => @call_from)}
        @status_maps = {:active => @approved_map}
      end
      
      it "with comment reject" do
        @comment.reject!
        actions = helper.generate_status_change_actions(@comment, "comment", @call_from)
        assert_generated_status_change_actions @status_maps, actions, :inactive
      end
    end
    
    def assert_generated_status_change_actions(status_maps, actions, curr_action)
      status_maps.each do |action, map|
        actions.should_not include(map) if action == curr_action
        actions.should include(map) if action != curr_action
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