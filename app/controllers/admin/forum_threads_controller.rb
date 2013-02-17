class Admin::ForumThreadsController < Admin::AdminController
  
  before_filter :init_obj_for_change_status, :only => [:change_status]
  
  # GET /admin/forum_threads
  # GET /admin/forum_threads.json
  def index
    respond_to do |format|
      format.html { 
        @forum_threads = ForumThread.search({:term => params[:q], 
                                            :status => params[:status], :forum_id => params[:forum_id]},
                                            params[:page])
      }
      format.js { render :json => parse_list_for_js_response(search_by_name(ForumThread)) }
    end
  end

  # GET /admin/forum_threads/1
  # GET /admin/forum_threads/1.json
  def show
    @forum_thread = ForumThread.find(params[:id])
    respond_to do |format|
      format.html
      format.js { render :json => parse_for_js_response(@forum_thread) }
    end
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
    
    def init_obj_for_change_status
      @obj = ForumThread.find(params[:id])
    end
end
