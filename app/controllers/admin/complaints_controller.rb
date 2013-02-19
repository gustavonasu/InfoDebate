# encoding: UTF-8

class Admin::ComplaintsController < Admin::AdminController

  before_filter :init_obj_for_change_status, :only => [:change_status]

  # GET /admin/complaints
  def index
    @complaints = Complaint.search({ :term => params[:q], 
                                     :comment_id => params[:comment_id],
                                     :user_id => params[:user_id],
                                     :status => params[:status]},
                                    params[:page])
    
  end

  # GET /admin/complaints/1
  def show
    @complaint = Complaint.find(params[:id])
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
    @complaint = Complaint.new(params[:complaint].except(:comment_id, :user_id))
    @complaint.comment = get_comment
    @complaint.user = get_user
    if @complaint.save
      redirect_to [:admin, @complaint], notice: t(:creation_success, scope: :action_messages, model: 'Reclamação')
    else
      render action: "new"
    end
  end

  # PUT /admin/complaints/1
  def update
    @complaint = Complaint.find(params[:id])
    if @complaint.update_attributes(params[:complaint].except(:comment_id, :user_id))
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
  
    def get_comment
      comment_id = params[:complaint][:comment_id]
      return nil if comment_id.blank?
      Comment.find(comment_id)
    end
    
    def get_user
      user_id = params[:complaint][:user_id] 
      return nil if user_id.blank?
      User.find(user_id)
    end
    
    def init_obj_for_change_status
      @obj = Complaint.find(params[:id])
    end
end
