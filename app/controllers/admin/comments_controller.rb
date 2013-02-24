# encoding: UTF-8

class Admin::CommentsController < Admin::AdminController

  before_filter :init_obj_for_change_status, :only => [:change_status]
  
  # GET /admin/comments
  # GET /admin/comments.json
  def index
    @comments = Comment.search({ :term => params[:q], 
                                 :thread_id => params[:thread_id],
                                 :user_id => params[:user_id],
                                 :status => params[:status]},
                               params[:page])
  end

  # GET /admin/comments/1
  # GET /admin/comments/1.json
  def show
    @comment = Comment.find(params[:id])
  end

  # GET /admin/comments/new
  def new
    @comment = Comment.new
  end

  # GET /admin/comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /admin/comments
  def create
    @comment = Comment.new(params[:comment].except(:thread_id, :user_id))
    @comment.thread = get_thread
    @comment.user = get_user
    if @comment.save
      redirect_to [:admin, @comment], notice: t(:creation_success, scope: :action_messages, model: 'Comentário')
    else
      render action: "new"
    end
  end

  # PUT /admin/comments/1
  def update
    @comment = Comment.find(params[:id])
    @comment.thread = get_thread
    @comment.user = get_user
    if @comment.update_attributes(params[:comment].except(:thread_id, :user_id))
      redirect_to [:admin, @comment], notice: t(:update_success, scope: :action_messages, model: 'Comentário')
    else
      render action: "edit"
    end
  end

  # DELETE /admin/comments/1
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_url, notice: t(:deletion_success, scope: :action_messages, model: 'Comentário')
  end
  
  private
    
    def get_thread
      thread_id = params[:comment][:thread_id] 
      return nil if thread_id.blank?
      ForumThread.find(thread_id)
    end
    
    def get_user
      user_id = params[:comment][:user_id] 
      return nil if user_id.blank?
      User.find(user_id)
    end
    
    def init_obj_for_change_status
      @obj = Comment.find(params[:id])
    end
end
