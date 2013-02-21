module Status
  module Callbacks
    
    def self.extended(base)
      base.instance_eval do
        def before_status_callbacks
          instance_variable_get("@before_status_callbacks")
        end
        def before_status_callbacks=(val)
          instance_variable_set("@before_status_callbacks", val)
        end
        def after_status_callbacks
          instance_variable_get("@after_status_callbacks")
        end
        def after_status_callbacks=(val)
          instance_variable_set("@after_status_callbacks", val)
        end
      end
      base.before_status_callbacks = base.all_status.inject({}) {|map,s| map[s] = []; map}
      base.after_status_callbacks = base.before_status_callbacks.dup
    end
    
    def def_before_status_change(*status_array, method_name)
      status_array.each do |status|
        before_status_callbacks[status] << method_name
      end
    end
    
    def def_after_status_change(*status_array, method_name)
      status_array.each do |status|
        after_status_callbacks[status] << method_name
      end
    end
    
    private
    
      def run_status_callbacks(status)
        run_before_status_callbacks(status)
        yield
        run_after_status_callbacks(status)
      end
      
      def run_before_status_callbacks(status)
        self.class.before_status_callbacks[status].each do |method|
          send(method, find_action(status))
        end
      end
      
      def run_after_status_callbacks(status)
        self.class.after_status_callbacks[status].each do |method|
          send(method, find_action(status))
        end
      end
  end
end