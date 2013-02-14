class Admin::ForumsController < ApplicationController
  # GET /admin/forums
  # GET /admin/forums.json
  def index
    respond_to do |format|
      format.html { 
        @forums = Forum.search({:term => params[:q], :status => params[:status]}, params[:page])
      }
      format.js {
        @forums = find_forums_for_js_response
        render :json => @forums.map {|f| {:id => f.id, :text => f.name} }
      }
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
  def new
    @forum = Forum.new
  end

  # GET /admin/forums/1/edit
  def edit
    @forum = Forum.find(params[:id])
  end

  # POST /admin/forums
  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      redirect_to [:admin, @forum], notice: 'Forum was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/forums/1
  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      redirect_to [:admin, @forum], notice: 'Forum was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /admin/forums/1
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    redirect_to admin_forums_url
  end
  
  private
  
    def find_forums_for_html_response
      Forum.search({:term => params[:q], :status => params[:status]}, params[:page])
    end
    
    def find_forums_for_js_response
      per_page = params[:limit] || PER_PAGE
      if !params[:name].blank?
        forums = Forum.search_by_name(params[:name], params[:page], per_page)
      else
        forums = Forum.paginate(:page => params[:page], :per_page => PER_PAGE)
      end
    end
end
