class Admin::ForumsController < ApplicationController
  # GET /admin/forums
  # GET /admin/forums.json
  def index
    @forums = Forum.paginate(:page => params[:page], :per_page => PER_PAGE)
  end

  # GET /admin/forums/1
  # GET /admin/forums/1.json
  def show
    @forum = Forum.find(params[:id])
  end

  # GET /admin/forums/new
  # GET /admin/forums/new.json
  def new
    @forum = Forum.new
  end

  # GET /admin/forums/1/edit
  def edit
    @forum = Forum.find(params[:id])
  end

  # POST /admin/forums
  # POST /admin/forums.json
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      redirect_to [:admin, @forum], notice: 'Forum was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/forums/1
  # PUT /admin/forums/1.json
  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      redirect_to [:admin, @forum], notice: 'Forum was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /admin/forums/1
  # DELETE /admin/forums/1.json
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    redirect_to admin_forums_url
  end
end
