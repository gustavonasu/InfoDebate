# encoding: UTF-8

class Admin::ComplaintsController < Admin::AdminController

  MASS_ATTR_EXCEPTIONS = [:comment_id, :user_id]

  before_filter :init_obj_for_change_status, :only => [:change_status]

  # GET /admin/complaints
  def index
    @complaints = Complaint.search({ :term => params[:q], 
                                     :comment_id => params[:comment_id],
                                     :user_id => params[:user_id],
                                     :thread_id => params[:thread_id],
                                     :forum_id => params[:forum_id],
                                     :status => params[:status]},
                                    params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def complaints
    @complaints = Complaint.search({:comment_id => params[:id]}, params[:page], LIGHTBOX_PER_PAGE)
    respond_to do |format|
      format.js
    end
  end

  # GET /admin/complaints/1
  # GET /admin/complaints/1.js
  def show
    @complaint = Complaint.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # GET /admin/complaint/1/show_modal/call_from
  # GET /admin/complaint/1/show_modal/call_from.js
  def show_modal
    @complaint = Complaint.find(params[:id])
    respond_to do |format|
      format.html { head :not_found }
      format.js
    end
  end
  
  # GET /admin/complaints/new
  def new
    @complaint = Complaint.new
  end

  # GET /admin/complaints/1/edit
  def edit
    @complaint = Complaint.find(params[:id])
  end

  # POST /admin/complaints
  def create
    @complaint = Complaint.new(params[:complaint].except(*MASS_ATTR_EXCEPTIONS))
    @complaint.comment = get_comment params[:complaint][:comment_id]
    @complaint.user = get_user params[:complaint][:user_id]
    if @complaint.save
      redirect_to [:admin, @complaint], notice: t(:creation_success, scope: :action_messages, model: 'Reclamação')
    else
      render action: "new"
    end
  end

  # PUT /admin/complaints/1
  def update
    @complaint = Complaint.find(params[:id])
    if @complaint.update_attributes(params[:complaint].except(*MASS_ATTR_EXCEPTIONS))
      redirect_to [:admin, @complaint], notice: t(:update_success, scope: :action_messages, model: 'Reclamação')
    else
      render action: "edit"
    end
  end

  # DELETE /admin/complaints/1
  def destroy
    @complaint = Complaint.find(params[:id])
    @complaint.destroy
    redirect_to admin_complaints_url, notice: t(:deletion_success, scope: :action_messages, model: 'Reclamação')
  end
  
  private
    
    def init_obj_for_change_status
      @obj = Complaint.find(params[:id])
    end
end
