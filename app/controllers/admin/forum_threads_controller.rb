class Admin::ForumThreadsController < ApplicationController
  # GET /admin/forum_threads
  # GET /admin/forum_threads.json
  def index
    @forum_threads = ForumThread.search({:term => params[:q], :status => params[:status]},
                                          params[:page])
  end

  # GET /admin/forum_threads/1
  # GET /admin/forum_threads/1.json
  def show
    @forum_thread = ForumThread.find(params[:id])
  end

  # GET /admin/forum_threads/new
  def new
    @forum_thread = ForumThread.new
  end

  # GET /admin/forum_threads/1/edit
  def edit
    @forum_thread = ForumThread.find(params[:id])
  end

  # POST /admin/forum_threads
  def create
    @forum_thread = ForumThread.new(params[:forum_thread].except(:forum_id))
    @forum_thread.forum = get_forum
    if @forum_thread.save
      redirect_to [:admin, @forum_thread], notice: 'Forum thread was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/forum_threads/1
  def update
    @forum_thread = ForumThread.find(params[:id])
    @forum_thread.forum = get_forum
    if @forum_thread.update_attributes(params[:forum_thread].except(:forum_id))
      redirect_to [:admin, @forum_thread], notice: 'Forum thread was successfully updated.'
    else
      render action: "edit"
    end
  end

  

  # DELETE /admin/forum_threads/1
  def destroy
    @forum_thread = ForumThread.find(params[:id])
    @forum_thread.destroy
    redirect_to admin_forum_threads_url
  end
  
  private
    
    def get_forum
      forum_id = params[:forum_thread][:forum_id] 
      return nil if forum_id.blank?
      Forum.find(forum_id)
    end
end
