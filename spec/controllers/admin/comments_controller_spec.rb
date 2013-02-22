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

describe Admin::CommentsController do
  include ControllerHelper

  before do
    @attrs = {:body => "Comment text"}
    @forum = FactoryGirl.create(:forum)
    @thread = FactoryGirl.create(:forum_thread, :forum => @forum)
    @user = FactoryGirl.create(:user)
  end
  
  def valid_attributes(attrs = @attrs, thread = @thread, user = @user)
    valid_attrs = attrs.dup
    valid_attrs[:thread_id] = thread.id
    valid_attrs[:user_id] = user.id
    valid_attrs
  end
  
  def create_comment(attrs = @attrs, thread = @thread, user = @user)
    comment = Comment.create(attrs)
    comment.thread = thread
    comment.user = user
    comment.save
    comment
  end
  
  def create_comments(total)
    comments = []
    total.times do
      thread = FactoryGirl.create(:forum_thread, :forum => @forum)
      user = FactoryGirl.create(:user, :name => FactoryGirl.generate(:name),
                                       :username => FactoryGirl.generate(:username),
                                       :email => FactoryGirl.generate(:email))
      comments << FactoryGirl.create(:comment, :body => FactoryGirl.generate(:text_comment),
                                               :thread => thread, :user => user)
    end
    comments
  end

  describe "GET index" do
    before do
      @comments = create_comments(10)
      @comment = @comments[-1]
    end
    
    it_should_behave_like "Controller Standard Search" do
      let(:instances) { @comments }
      let(:instance) { @comment }
      let(:instances_symbol) { :comments }
    end
    
    describe "Special search cases" do
      it "assigns comments searching by thread_id" do
        get :index, {:thread_id => @comment.thread.id}
        assigns(:comments).should eq([@comment])
      end
      
      it "assigns comments searching by user_id" do
        get :index, {:user_id => @comment.user.id}
        assigns(:comments).should eq([@comment])
      end
      
      it "assigns comments searching by thread_id and user_id" do
        get :index, {:thread_id => @comment.thread.id, :user_id => @comment.user.id}
        assigns(:comments).should eq([@comment])
      end
    end
  end

  describe "GET show" do
    it "assigns the requested admin_comment as @comment" do
      comment = create_comment
      get :show, {:id => comment.to_param}
      assigns(:comment).should eq(comment)
    end
  end

  describe "GET new" do
    it "assigns a new admin_comment as @comment" do
      get :new, {}
      assigns(:comment).should be_a_new(Comment)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_comment as @comment" do
      comment = create_comment
      get :edit, {:id => comment.to_param}
      assigns(:comment).should eq(comment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, {:comment => valid_attributes}
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created admin_comment as @comment" do
        post :create, {:comment => valid_attributes}
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
      end

      it "redirects to the created admin_comment" do
        post :create, {:comment => valid_attributes}
        response.should redirect_to([:admin, Comment.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin_comment as @comment" do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, {:comment => {}}
        assigns(:comment).should be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        post :create, {:comment => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin_comment" do
        comment = create_comment
        # Assuming there are no other admin_comments in the database, this
        # specifies that the Comment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Comment.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => comment.to_param, :comment => {'these' => 'params'}}
      end

      it "assigns the requested admin_comment as @comment" do
        comment = create_comment
        put :update, {:id => comment.to_param, :comment => valid_attributes}
        assigns(:comment).should eq(comment)
      end

      it "redirects to the admin_comment" do
        comment = create_comment
        put :update, {:id => comment.to_param, :comment => valid_attributes}
        response.should redirect_to([:admin, comment])
      end
    end

    describe "with invalid params" do
      it "assigns the admin_comment as @comment" do
        comment = create_comment
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        put :update, {:id => comment.to_param, :comment => {}}
        assigns(:comment).should eq(comment)
      end

      it "re-renders the 'edit' template" do
        comment = create_comment
        # Trigger the behavior that occurs when invalid params are submitted
        Comment.any_instance.stub(:save).and_return(false)
        put :update, {:id => comment.to_param, :comment => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @comment = create_comment
      @comment.save
    end
    
    it "destroys the requested admin_comment" do
      expect {
        delete :destroy, {:id => @comment.to_param}
      }.to change(Comment, :count).by(-1)
      @comment.reload.should be_deleted
    end
    
    it "redirects to the admin_comments list" do
      delete :destroy, {:id => @comment.to_param}
      response.should redirect_to(admin_comments_url)
    end
  end

  describe "CHANGE_STATUS request" do
    before do
      @comment = create_comment
      @comment.save
    end
    
    context "Valid status" do
      Comment.target_status.each do |status|
        it_should_behave_like "valid #{status} status change" do
          subject { @comment }
        end
      end
    end
    
    context "Invalid status" do
      Comment.invalid_status.each do |status|
        it_should_behave_like "invalid #{status} status change" do
          subject { @comment }
        end
      end
    end
  end

end