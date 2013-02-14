class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # TODO Avaliar se é necessário criar um módulo (qual??) para acomodar esses métodos
  
  def search_by_name(type)
    per_page = params[:limit] || PER_PAGE
    if !params[:name].blank?
      type.search_by_name(params[:name], params[:page], per_page)
    else
      type.paginate(:page => params[:page], :per_page => PER_PAGE)
    end
  end
  
  def parse_for_js_response(instances)
    instances.map {|f| {:id => f.id, :text => f.name} }
  end
end
