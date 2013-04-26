# encoding: UTF-8

class Admin::CommentsController < Admin::AdminController

  MASS_ATTR_EXCEPTIONS = [:thread_id, :user_id, :parent_id]
  
  before_filter :init_obj_for_change_status, :only => [:change_status]
  
  # GET /admin/comments
  # GET /admin/comments.js
  def index
    @comments = Comment.search({ :term => params[:q], 
                                 :thread_id => params[:thread_id],
                                 :user_id => params[:user_id],
                                 :status => params[:status]},
                               params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def answers
    @answers = Comment.search({:parent_id => params[:id], :status => :all},
                              params[:page], LIGHTBOX_PER_PAGE)
    respond_to do |format|
      format.js
    end
  end

  # GET /admin/comments/1
  # GET /admin/comments/1.js
  def show
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /admin/comments/1/show_modal/call_from
  # GET /admin/comments/1/show_modal/call_from.js
  def show_modal
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.html { head :not_found }
      format.js
    end
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
    @comment = Comment.new(params[:comment].except(*MASS_ATTR_EXCEPTIONS))
    @comment.thread = get_thread params[:comment][:thread_id]
    @comment.user = get_user params[:comment][:user_id] 
    @comment.parent = get_comment params[:comment][:parent_id] 
    if @comment.save
      redirect_to [:admin, @comment], notice: t(:creation_success, scope: :action_messages, model: 'Comentário')
    else
      render action: "new"
    end
  end

  # PUT /admin/comments/1
  def update
    @comment = Comment.find(params[:id])
    @comment.thread = get_thread params[:comment][:thread_id]
    @comment.user = get_user params[:comment][:user_id] 
    @comment.parent = get_comment params[:comment][:parent_id] 
    if @comment.update_attributes(params[:comment].except(*MASS_ATTR_EXCEPTIONS))
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
    
    def init_obj_for_change_status
      @obj = Comment.find_by_id(params[:id])
    end
end
