# encoding: UTF-8

class Admin::AdminController < ApplicationController
  
  # TODO Avaliar se é necessário criar um módulo (qual??) para acomodar esses métodos
  
  def search_by_name(type)
    per_page = params[:limit] || PER_PAGE
    if !params[:name].blank?
      type.search_by_name(params[:name], params[:page], per_page)
    else
      type.paginate(:page => params[:page], :per_page => PER_PAGE)
    end
  end
  
  def parse_list_for_js_response(instances)
    instances.map {|obj| parse_for_js_response(obj) }
  end
  
  def parse_for_js_response(obj)
    {:id => obj.id, :text => obj.name}
  end
  
  def change_status
    begin
      @obj.send("#{params[:status_action]}!")
      notice = t(:success, :scope => :status_action_message)
    rescue Status::InvalidStatusError, Status::Un_TargetStatusError, Status::TerminalStatusError => e
      error = t(:invalid, :scope => :status_action_message)
    rescue Exception => e
      error = "Ocorreu um error na requisição"
    end
    respond_to do |format|
      format.html do
        flash[:notice] = notice
        flash[:error] = error
        if @obj.deleted?
          redirect_to :action => :index
        else
          redirect_to [:admin, @obj]
        end
      end
      format.js do
        request[:notice] = notice
        request[:error] = error
      end
    end
  end
  
  def get_forum(forum_id)
    return nil if forum_id.blank?
    Forum.find(forum_id)
  end
  
  def get_thread(thread_id)
    return nil if thread_id.blank?
    ForumThread.find(thread_id)
  end
  
  def get_user(user_id)
    return nil if user_id.blank?
    User.find(user_id)
  end
  
  def get_comment(comment_id)
    return nil if comment_id.blank?
    Comment.find(comment_id)
  end
end