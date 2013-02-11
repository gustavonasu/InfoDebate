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

  before do
    @forum = FactoryGirl.create(:forum)
    @forum_thread = FactoryGirl.create(:forum_thread, valid_attributes.merge(:forum => @forum))
  end

  # This should return the minimal set of attributes required to create a valid
  # ForumThread. As you add validations to ForumThread, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:name => "Thread Name"}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ForumThreadsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  def create_thread_form(forum_thread_attrs = valid_attributes)
    {:forum_thread => forum_thread_attrs.merge(:forum_id => @forum.id)}
  end

  describe "GET index" do
    it "assigns all admin_forum_threads as @forum_threads" do
      get :index, {}, valid_session
      assigns(:forum_threads).should eq([@forum_thread])
    end
  end

  describe "GET show" do
    it "assigns the requested admin_forum_thread as @forum_thread" do
      get :show, {:id => @forum_thread.to_param}, valid_session
      assigns(:forum_thread).should eq(@forum_thread)
    end
  end

  describe "GET new" do
    it "assigns a new admin_forum_thread as @forum_thread" do
      get :new, {}, valid_session
      assigns(:forum_thread).should be_a_new(ForumThread)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_forum_thread as @forum_thread" do
      get :edit, {:id => @forum_thread.to_param}, valid_session
      assigns(:forum_thread).should eq(@forum_thread)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ForumThread" do
        expect {
          post :create, create_thread_form, valid_session
        }.to change(ForumThread, :count).by(1)
      end

      it "assigns a newly created admin_forum_thread as @forum_thread" do
        post :create, create_thread_form, valid_session
        assigns(:forum_thread).should be_a(ForumThread)
        assigns(:forum_thread).should be_persisted
      end

      it "redirects to the created admin_forum_thread" do
        post :create, create_thread_form, valid_session
        response.should redirect_to([:admin, ForumThread.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin_forum_thread as @forum_thread" do
        # Trigger the behavior that occurs when invalid params are submitted
        ForumThread.any_instance.stub(:save).and_return(false)
        post :create, create_thread_form({}), valid_session
        assigns(:forum_thread).should be_a_new(ForumThread)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ForumThread.any_instance.stub(:save).and_return(false)
        post :create, create_thread_form({}), valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin_forum_thread" do
        # Assuming there are no other admin_forum_threads in the database, this
        # specifies that the ForumThread created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ForumThread.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => @forum_thread.to_param}.merge(create_thread_form({'these' => 'params'})), valid_session
      end

      it "assigns the requested admin_forum_thread as @forum_thread" do
        put :update, {:id => @forum_thread.to_param}.merge(create_thread_form), valid_session
        assigns(:forum_thread).should eq(@forum_thread)
      end

      it "redirects to the admin_forum_thread" do
        put :update, {:id => @forum_thread.to_param}.merge(create_thread_form), valid_session
        response.should redirect_to([:admin, @forum_thread])
      end
    end

    describe "with invalid params" do
      it "assigns the admin_forum_thread as @forum_thread" do
        # Trigger the behavior that occurs when invalid params are submitted
        ForumThread.any_instance.stub(:save).and_return(false)
        put :update, {:id => @forum_thread.to_param}.merge(create_thread_form({})), valid_session
        assigns(:forum_thread).should eq(@forum_thread)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ForumThread.any_instance.stub(:save).and_return(false)
        put :update, {:id => @forum_thread.to_param}.merge(create_thread_form({})), valid_session
        response.should render_template("edit")
      end
    end
    
    describe "Update Forum association" do
      it "should update Forum association" do
        new_forum = FactoryGirl.create(:forum)
        attrs = {:id => @forum_thread.to_param,
                 :forum_thread => {:name => @forum_thread.name,
                                  :forum_id => new_forum.id } }
        put :update, attrs
        ForumThread.find(@forum_thread.id).forum_id.should eq(new_forum.id)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin_forum_thread" do
      expect {
        delete :destroy, {:id => @forum_thread.to_param}, valid_session
      }.to_not change(ForumThread, :count)
      ForumThread.find(@forum).deleted?.should be_true
    end

    it "redirects to the admin_forum_threads list" do
      delete :destroy, {:id => @forum_thread.to_param}, valid_session
      response.should redirect_to(admin_forum_threads_url)
    end
  end

end
