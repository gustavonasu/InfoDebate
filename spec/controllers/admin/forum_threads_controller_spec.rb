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

describe Admin::ForumThreadsController do
  include ControllerHelper
  
  before do
    @forum = FactoryGirl.create(:forum)
    @forum_thread = FactoryGirl.create(:forum_thread, valid_attributes.merge(:forum => @forum))
  end

  def valid_attributes
    {:name => "Thread Name", :forum_id => @forum.id}
  end

  def create_thread_map(forum_thread_attrs = valid_attributes)
    {:forum_thread => forum_thread_attrs}
  end

  describe "GET index" do
    before do
      @forum_threads = [@forum_thread]
      10.times do
        @forum_threads << FactoryGirl.create(:forum_thread,
                                  :forum => @forum)
      end
    end
    
    context "html request" do
      it_should_behave_like "Controller Standard Search" do
        let(:instances) { @forum_threads }
        let(:instance) { @forum_thread }
        let(:instances_symbol) { :forum_threads }
      end
    
      describe "Special search cases" do
        before do
          @another_forum = FactoryGirl.create(:forum)
          @another_thread = FactoryGirl.create(:forum_thread, :forum => @another_forum)
        end
      
        it "assigns forums searching by forum_id" do
          get :index, {:forum_id => @another_forum.id}
          assigns(:forum_threads).should eq([@another_thread])
        end
      end
    end
    
    context "js request" do
      it_should_behave_like "Controller js Search" do
        subject { @forum_threads }
      end
    end
  end

  describe "GET show" do
    context "html request" do
      it "assigns the requested admin_forum_thread as @forum_thread" do
        get :show, {:id => @forum_thread.to_param}
        assigns(:forum_thread).should eq(@forum_thread)
      end
    end
    
    context "js request" do
      it_should_behave_like "Controller js Show" do
        subject { @forum_thread }
      end
    end
  end

  describe "GET new" do
    it "assigns a new admin_forum_thread as @forum_thread" do
      get :new, {}
      assigns(:forum_thread).should be_a_new(ForumThread)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_forum_thread as @forum_thread" do
      get :edit, {:id => @forum_thread.to_param}
      assigns(:forum_thread).should eq(@forum_thread)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ForumThread" do
        expect {
          post :create, create_thread_map
        }.to change(ForumThread, :count).by(1)
      end

      it "assigns a newly created admin_forum_thread as @forum_thread" do
        post :create, create_thread_map
        assigns(:forum_thread).should be_a(ForumThread)
        assigns(:forum_thread).should be_persisted
      end

      it "redirects to the created admin_forum_thread" do
        post :create, create_thread_map
        response.should redirect_to([:admin, ForumThread.last])
      end
    end

    describe "with invalid params" do
      before do
        @thread_map = create_thread_map(:name => "", :forum_id => "")
      end
      
      it "assigns a newly created but unsaved admin_forum_thread as @forum_thread" do
        # Trigger the behavior that occurs when invalid params are submitted
        ForumThread.any_instance.stub(:save).and_return(false)
        post :create, @thread_map
        assigns(:forum_thread).should be_a_new(ForumThread)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ForumThread.any_instance.stub(:save).and_return(false)
        post :create, @thread_map
        response.should render_template("new")
      end
      
      it "should return field with errors" do
        post :create, @thread_map
        assigns(:forum_thread).errors[:name].should cannot_be_blank
        assigns(:forum_thread).errors[:forum_id].should cannot_be_blank
      end
    end
  end

  describe "PUT update" do
    before do
      @update_map = {:id => @forum_thread.to_param}
    end
    
    describe "with valid params" do
      it "updates the requested admin_forum_thread" do
        # Assuming there are no other admin_forum_threads in the database, this
        # specifies that the ForumThread created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ForumThread.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, @update_map.merge(create_thread_map({'these' => 'params'}))
      end

      it "assigns the requested admin_forum_thread as @forum_thread" do
        put :update, @update_map.merge(create_thread_map)
        assigns(:forum_thread).should eq(@forum_thread)
      end

      it "redirects to the admin_forum_thread" do
        put :update, @update_map.merge(create_thread_map)
        response.should redirect_to([:admin, @forum_thread])
      end
    end

    describe "with invalid params" do
      before do
        @thread_map = create_thread_map(:name => "", :forum_id => "")
      end
      
      it "assigns the admin_forum_thread as @forum_thread" do
        # Trigger the behavior that occurs when invalid params are submitted
        ForumThread.any_instance.stub(:save).and_return(false)
        put :update, @update_map.merge(@thread_map)
        assigns(:forum_thread).should eq(@forum_thread)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ForumThread.any_instance.stub(:save).and_return(false)
        put :update, @update_map.merge(@thread_map)
        response.should render_template("edit")
      end
      
      it "should return field with errors" do
        put :update, @update_map.merge(@thread_map)
        assigns(:forum_thread).errors[:name].should cannot_be_blank
        assigns(:forum_thread).errors[:forum_id].should cannot_be_blank
      end
    end
    
    describe "Update Forum association" do
      it "should update Forum association" do
        new_forum = FactoryGirl.create(:forum)
        put :update, @update_map.merge(create_thread_map(:name => @forum_thread.name,
                                                      :forum_id => new_forum.id))
        ForumThread.find(@forum_thread.id).forum_id.should eq(new_forum.id)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin_forum_thread" do
      expect {
        delete :destroy, {:id => @forum_thread.to_param}
      }.to change(ForumThread, :count).by(-1)
      @forum_thread.reload.should be_deleted
    end
    
    it "redirects to the admin_forum_threads list" do
      delete :destroy, {:id => @forum_thread.to_param}
      response.should redirect_to(admin_forum_threads_url)
    end
  end

  describe "CHANGE_STATUS request" do
    context "Valid status" do
      ForumThread.target_status.each do |status|
        it_should_behave_like "valid #{status} status change" do
          subject { @forum_thread }
        end
      end
    end
    
    context "Invalid status" do
      ForumThread.invalid_status.each do |status|
        it_should_behave_like "invalid #{status} status change" do
          subject { @forum_thread }
        end
      end
    end
  end

end
