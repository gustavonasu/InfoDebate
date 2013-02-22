module Admin::ApplicationHelper
  
  def status_url(status)
    url = request.fullpath.dup
    url.sub!(/status=[^&]*/, "")
    url.sub!(/\?&/, "?")
    url.sub!(/&&/, "&")
    url += "&" if url.include?("?") && !url.ends_with?("&")
    url += "?" if !url.include?("?")
    url += "status=#{status}"
  end
  
  ACTION_CONFIG_BY_STATUS = {:active => {:default_map => {:type => "info"}, 
                                         :path_pattern => 'change_status_admin_#{resource_name}_path',
                                         :include_param_action => true},
                             :inactive => {:default_map => {:type => "warning"},
                                           :path_pattern => 'change_status_admin_#{resource_name}_path',
                                           :include_param_action => true, :confirmation => true},
                             :pending => {:default_map => {:type => "warning"},
                                          :path_pattern => 'change_status_admin_#{resource_name}_path',
                                          :include_param_action => true, :confirmation => true},
                             :ban => {:default_map => {:type => "danger"},
                                      :path_pattern => 'change_status_admin_#{resource_name}_path',
                                      :include_param_action => true, :confirmation => true},
                             :delete => {:default_map => {:type => "danger", :method => "delete"}, 
                                         :path_pattern => 'admin_#{resource_name}_path',
                                         :confirmation => true}}
                             
  
  def generate_status_change_actions(obj, resource_name)
    actions = []
    obj.target_status_for(obj.status).each do |status|
      action = obj.find_action(status)
      action_config = ACTION_CONFIG_BY_STATUS[action]
      action_map = action_config[:default_map]
      action_map.merge! build_action_label(action)
      action_map.merge! build_action_path(obj, action, resource_name)
      action_map.merge! build_action_confirmation() if action_config[:confirmation] == true
      actions << action_map
    end
    actions
  end
  
  private
    
    def build_action_label(action)
      {:label => t(action, :scope => :status_action)}
    end
    
    def build_action_path(obj, action, resource_name)
      path_pattern = ACTION_CONFIG_BY_STATUS[action][:path_pattern]
      path_name = Kernel.eval("\"" + path_pattern + "\"")
      params = {:status_action => action} if ACTION_CONFIG_BY_STATUS[action][:include_param_action] == true
      path = Rails.application.routes.url_helpers.send(path_name, obj, params)
      {:path => path}
    end
    
    def build_action_confirmation
      {:confirmation_msg => t(:confirmation_msg)}
    end
end
