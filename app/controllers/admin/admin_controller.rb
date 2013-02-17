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
      @obj.send(params[:status_action])
      @obj.save
      message = {notice: t(:success, :scope => :status_action_message)}
    rescue InvalidStatus => e
      message = {flash: {error: t(:invalid, :scope => :status_action_message)}}
    end
    redirect_to [:admin, @obj], message
  end
end