class Admin::UsersController < Admin::AdminController
  # GET /users
  def index
    respond_to do |format|
      format.html { @users = User.search({:term => params[:q], :status => params[:status]}, params[:page]) }
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
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
      redirect_to [:admin, @user], notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to [:admin, @user], notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path(:page => params[:page]), :notice => 'User was successfully deleted.'
  end
end