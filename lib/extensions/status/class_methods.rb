module Status
  module ClassMethods
    
    def all_status; ModelStatus.all_status end    
    
    def def_valid_status(*status_param)
      define_singleton_method :valid_status do
        status_param
      end
    end
    
    def invalid_status
      all_status - valid_status
    end
    
    def target_status_for(status)
      return [] if terminal_status.include?(status)
      target_status - [status]
    end
    
    def target_status
      valid_status - un_target_status
    end
    
    # Default Un-target status is empty
    def un_target_status; [] end 
    
    def def_un_target_status(*status_param)
      define_singleton_method :un_target_status do
        status_param
      end
    end
    
    # Default Terminal status is empty
    def terminal_status; [] end
    
    def def_terminal_status(*status_param)
      define_singleton_method :terminal_status do
        status_param
      end
    end
    
    def def_contraints_to_target_status(method)
      define_method :_contraints_to_target_status do |status|
        send(method, status)
      end
    end
    
    def find_action(status)
      ModelStatus.find_action(status)
    end
    
    def find_status_value(status)
      ModelStatus.find_status_value(status)
    end
    
    def find_status(value)
      ModelStatus.find_status(value)
    end
  end
end