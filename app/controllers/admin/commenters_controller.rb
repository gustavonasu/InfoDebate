
class Admin::CommentersController < ApplicationController
  # GET /commenters
  def index
    @commenters = Commenter.paginate(:page => params[:page], :per_page => PER_PAGE)
  end

  # GET /commenters/1
  def show
    @commenter = Commenter.find(params[:id])
  end

  # GET /commenters/new
  def new
    @commenter = Commenter.new
  end

  # GET /commenters/1/edit
  def edit
    @commenter = Commenter.find(params[:id])
  end

  # POST /commenters
  def create
    @commenter = Commenter.new(params[:commenter])
    if @commenter.save
      redirect_to [:admin, @commenter], notice: 'Commenter was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /commenters/1
  def update
    @commenter = Commenter.find(params[:id])
    if @commenter.update_attributes(params[:commenter])
      redirect_to [:admin, @commenter], notice: 'Commenter was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /commenters/1
  def destroy
    @commenter = Commenter.find(params[:id])
    @commenter.destroy
    redirect_path = request.env["HTTP_REFERER"] || admin_commenters_path
    redirect_to redirect_path, notice: 'Commenter was successfully deleted.'
  end
end