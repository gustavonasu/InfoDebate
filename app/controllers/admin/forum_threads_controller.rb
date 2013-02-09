class Admin::ForumThreadsController < ApplicationController
  # GET /admin/forum_threads
  # GET /admin/forum_threads.json
  def index
    @forum_threads = ForumThread.all
  end

  # GET /admin/forum_threads/1
  # GET /admin/forum_threads/1.json
  def show
    @forum_thread = ForumThread.find(params[:id])
  end

  # GET /admin/forum_threads/new
  # GET /admin/forum_threads/new.json
  def new
    @forum_thread = ForumThread.new
  end

  # GET /admin/forum_threads/1/edit
  def edit
    @forum_thread = ForumThread.find(params[:id])
  end

  # POST /admin/forum_threads
  # POST /admin/forum_threads.json
  def create
    @forum_thread = ForumThread.new(params[:forum_thread])
    @forum_thread.forum = Forum.find(params[:forum_id])
    if @forum_thread.save
      redirect_to [:admin, @forum_thread], notice: 'Forum thread was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/forum_threads/1
  # PUT /admin/forum_threads/1.json
  def update
    @forum_thread = ForumThread.find(params[:id])
    if @forum_thread.update_attributes(params[:forum_thread])
      redirect_to [:admin, @forum_thread], notice: 'Forum thread was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /admin/forum_threads/1
  # DELETE /admin/forum_threads/1.json
  def destroy
    @forum_thread = ForumThread.find(params[:id])
    @forum_thread.destroy
    redirect_to admin_forum_threads_url
  end
end
