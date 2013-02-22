module Status
  module Callbacks
    
    def self.extended(base)
      base.instance_eval do
        def _initial_status_callback
          instance_variable_get("@initial_status_callback")
        end
        def _initial_status_callback=(val)
          instance_variable_set("@initial_status_callback", val)
        end
        def _before_status_callbacks
          instance_variable_get("@before_status_callbacks")
        end
        def _before_status_callbacks=(val)
          instance_variable_set("@before_status_callbacks", val)
        end
        def _after_status_callbacks
          instance_variable_get("@after_status_callbacks")
        end
        def _after_status_callbacks=(val)
          instance_variable_set("@after_status_callbacks", val)
        end
      end
      base._before_status_callbacks = base.all_status.inject({}) {|map,s| map[s] = []; map}
      base._after_status_callbacks = base._before_status_callbacks.dup
      base._initial_status_callback = {}
    end
    
    def def_initial_status_proc(method_name)
      _initial_status_callback[:method] = method_name
    end
    
    def def_initial_status(status)
      _initial_status_callback[:proc] = proc { status }
    end
    
    def def_before_status_change(*status_array, method_name)
      status_array.flatten.each do |status|
        _before_status_callbacks[status] << method_name
      end
    end
    
    def def_after_status_change(*status_array, method_name)
      status_array.flatten.each do |status|
        _after_status_callbacks[status] << method_name
      end
    end
    
    private
      
      def run_initial_status_callback
        if self.class._initial_status_callback[:proc]
          self.class._initial_status_callback[:proc].call
        elsif self.class._initial_status_callback[:method]
          send(self.class._initial_status_callback[:method])
        end
      end
      
      def run_status_callbacks(status)
        # TODO change this to pass old status, new status
        run_before_status_callbacks(status)
        yield
        run_after_status_callbacks(status)
      end
      
      def run_before_status_callbacks(status)
        self.class._before_status_callbacks[status].each do |method|
          send(method, find_action(status))
        end
      end
      
      def run_after_status_callbacks(status)
        self.class._after_status_callbacks[status].each do |method|
          send(method, find_action(status))
        end
      end
  end
end