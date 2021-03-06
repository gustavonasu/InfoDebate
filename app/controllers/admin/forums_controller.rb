# encoding: UTF-8

class Admin::ForumsController < Admin::AdminController

  before_filter :init_obj_for_change_status, :only => [:change_status]

  # GET /admin/forums
  # GET /admin/forums.json
  def index
    respond_to do |format|
      format.html { @forums = Forum.search({:term => params[:q], :status => params[:status]}, params[:page]) }
      format.json { render :json => parse_list_for_js_response(search_by_name(Forum)) }
    end
  end

  # GET /admin/forums/1
  # GET /admin/forums/1.json
  def show
    @forum = Forum.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => parse_for_js_response(@forum) }
    end
  end

  # GET /admin/forums/1/show_modal
  def show_modal
    @forum = Forum.find(params[:id])
    respond_to do |format|
      format.html { head :not_found }
      format.js
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
      redirect_to [:admin, @forum], notice: t(:creation_success, scope: :action_messages, model: 'Forum')
    else
      render action: "new"
    end
  end

  # PUT /admin/forums/1
  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      redirect_to [:admin, @forum], notice: t(:update_success, :scope => :action_messages, :model => 'Forum')
    else
      render action: "edit"
    end
  end

  # DELETE /admin/forums/1
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    redirect_to admin_forums_url, notice: t(:deletion_success, :scope => :action_messages, :model => 'Forum')
  end

  private
  
    def init_obj_for_change_status
      @obj = Forum.find(params[:id])
    end
end
