# encoding: UTF-8


class Admin::UsersController < Admin::AdminController
  
  before_filter :init_obj_for_change_status, :only => [:change_status]
  
  # GET /users
  def index
    respond_to do |format|
      format.html { @users = User.search({:term => params[:q], :status => params[:status]}, params[:page]) }
      format.js { render :json => parse_list_for_js_response(search_by_name(User)) }
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.js { render :json => parse_for_js_response(@user) }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to [:admin, @user], notice: t(:creation_success, scope: :action_messages, model: 'Usuário')
    else
      render action: "new"
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to [:admin, @user], notice: t(:update_success, scope: :action_messages, model: 'Usuário')
    else
      render action: "edit"
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: t(:deletion_success, scope: :action_messages, model: 'Usuário')
  end
  
  private
  
    def init_obj_for_change_status
      @obj = User.find(params[:id])
    end
end