class Admin::ForumsController < ApplicationController
  # GET /admin/forums
  # GET /admin/forums.json
  def index
    per_page = params[:limit] || PER_PAGE
    unless params[:name].blank?
      @forums = Forum.search_by_name(params[:name], per_page, params[:page])
    else
      @forums = Forum.paginate(:page => params[:page], :per_page => per_page)
    end
    
    respond_to do |format|
      format.html
      format.js { render :json => @forums.map {|f| {:id => f.id, :text => f.name} } }
    end
  end

  # GET /admin/forums/1
  # GET /admin/forums/1.json
  def show
    @forum = Forum.find(params[:id])
    respond_to do |format|
      format.html
      format.js { render :json => {:id => @forum.id, :text => @forum.name} }
    end
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
