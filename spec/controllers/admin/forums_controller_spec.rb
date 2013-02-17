require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Admin::ForumsController do
  include ControllerHelper
  
  # This should return the minimal set of attributes required to create a valid
  # Forum. As you add validations to Forum, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:name => "Forum Name"}
  end

  describe "GET index" do
    before do
      @forums = []
      10.times do
        @forums << FactoryGirl.create(:forum,
                                      :name => FactoryGirl.generate(:forum_name),
                                      :description => FactoryGirl.generate(:forum_name))
      end
    end
    
    context "html request" do
      before do
        @forum = @forums[-1]
      end
      
      it_should_behave_like "Controller Standard Search" do
        let(:instances) { @forums }
        let(:instance) { @forum }
        let(:instances_symbol) { :forums }
      end
    end
    
    context "js request" do
      it_should_behave_like "Controller js Search" do
        subject { @forums }
      end
    end
  end

  describe "GET show" do
    before do
      @forum = Forum.create! valid_attributes
    end
    
    context "html request" do
      it "assigns the requested admin_forum as @forum" do
        get :show, {:id => @forum.to_param}
        assigns(:forum).should eq(@forum)
      end
    end
    
    context "js request" do
      it_should_behave_like "Controller js Show" do
        subject { @forum }
      end
    end
  end

  describe "GET new" do
    it "assigns a new admin_forum as @forum" do
      get :new, {}
      assigns(:forum).should be_a_new(Forum)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_forum as @forum" do
      forum = Forum.create! valid_attributes
      get :edit, {:id => forum.to_param}
      assigns(:forum).should eq(forum)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Forum" do
        expect {
          post :create, {:forum => valid_attributes}
        }.to change(Forum, :count).by(1)
      end

      it "assigns a newly created admin_forum as @forum" do
        post :create, {:forum => valid_attributes}
        assigns(:forum).should be_a(Forum)
        assigns(:forum).should be_persisted
      end

      it "redirects to the created admin_forum" do
        post :create, {:forum => valid_attributes}
        response.should redirect_to([:admin, Forum.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin_forum as @forum" do
        # Trigger the behavior that occurs when invalid params are submitted
        Forum.any_instance.stub(:save).and_return(false)
        post :create, {:forum => {}}
        assigns(:forum).should be_a_new(Forum)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Forum.any_instance.stub(:save).and_return(false)
        post :create, {:forum => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin_forum" do
        forum = Forum.create! valid_attributes
        # Assuming there are no other admin_forums in the database, this
        # specifies that the Forum created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Forum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => forum.to_param, :forum => {'these' => 'params'}}
      end

      it "assigns the requested admin_forum as @forum" do
        forum = Forum.create! valid_attributes
        put :update, {:id => forum.to_param, :forum => valid_attributes}
        assigns(:forum).should eq(forum)
      end

      it "redirects to the admin_forum" do
        forum = Forum.create! valid_attributes
        put :update, {:id => forum.to_param, :forum => valid_attributes}
        response.should redirect_to([:admin, forum])
      end
    end

    describe "with invalid params" do
      it "assigns the admin_forum as @forum" do
        forum = Forum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Forum.any_instance.stub(:save).and_return(false)
        put :update, {:id => forum.to_param, :forum => {}}
        assigns(:forum).should eq(forum)
      end

      it "re-renders the 'edit' template" do
        forum = Forum.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Forum.any_instance.stub(:save).and_return(false)
        put :update, {:id => forum.to_param, :forum => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin_forum" do
      forum = Forum.create! valid_attributes
      init_count = Forum.unscoped.count
      delete :destroy, {:id => forum.to_param}
      Forum.unscoped.count.should eq(init_count)
      Forum.unscoped.find(forum).deleted?.should be_true
    end

    it "redirects to the admin_forums list" do
      forum = Forum.create! valid_attributes
      delete :destroy, {:id => forum.to_param}
      response.should redirect_to(admin_forums_url)
    end
  end

  describe "CHANGE_STATUS request" do
    before do
      @forum = Forum.create! valid_attributes
    end
    
    context "Valid status" do
      Forum.valid_status.reject{|s| s == :deleted}.each do |status|
        it_should_behave_like "valid #{status} status change" do
          subject { @forum }
        end
      end
    end
    
    context "Invalid status" do
      (ModelHelper.all_status - Forum.valid_status).each do |status|
        it_should_behave_like "invalid #{status} status change" do
          subject { @forum }
        end
      end
    end
  end
end
