module Status
  module ModelStatus
    include Callbacks
  
    def self.included(base)
      base.extend(ClassMethods)
      base.extend(Callbacks)
    end
    
    STATUS = { :active => 1,
               :inactive => 2,
               :banned => 3,
               :pending => 4,
               :deleted => 5,
               :approved => 6,
               :rejected => 7,
               :spam => 8 }
    
    STATUS_ACTION_MAP = { :active => :active,
                          :inactive => :inactive,
                          :banned => :ban,
                          :pending => :pending,
                          :deleted => :delete,
                          :approved => :approve,
                          :rejected => :reject,
                          :spam => :spam }
    
    def self.all_status; STATUS.keys end
    def self.find_action(status); STATUS_ACTION_MAP[status.to_sym] end
    def self.find_status_value(status); STATUS[status.to_sym] end 
    def self.find_status(value); STATUS.key(value) end
    
    # Metodos de instância relacionados a lista de status
    def all_status; self.class.all_status end
    def valid_status; self.class.valid_status end
    def invalid_status; self.class.invalid_status end
    def target_status_for(status); self.class.target_status_for(status) end
    def target_status; self.class.target_status end
    def un_target_status; self.class.un_target_status end
    def terminal_status; self.class.terminal_status end
    
    def status
      s = find_status(read_attribute(:status))
      self.status = s = run_initial_status_callback if s.nil?
      s
    end
    
    # Metodos helper de instância
    def find_action(status); self.class.find_action(status) end
    def find_status_value(status); self.class.find_status_value(status) end
    def find_status(value); self.class.find_status(value) end
    
    # Metodos de instância alteração de status
    ModelStatus.all_status.each do |s|
      action = find_action(s)
      define_method "#{action}" do
        run_status_callbacks(s) { send(:status=, s) }
      end
      
      define_method "#{action}!" do
        ActiveRecord::Base.transaction do
          send("#{action}")
          save!
        end
      end
      
      define_method "#{s}?" do
        s == status
      end
    end
    
    # Disable destroy object
    # TODO This options is hard coded as well as delete status.
    def destroy; delete! end
    
    private

      def status=(s)
        validate_status_change(s)
        write_attribute :status, find_status_value(s)
      end
      
      def validate_status_change(s)
        raise InvalidStatusError if self.invalid_status.include?(s)
        raise Un_TargetStatusError if self.un_target_status.include?(s)
        curr_status = find_status(read_attribute(:status))
        if self.terminal_status.include?(curr_status) && s != curr_status
          raise TerminalStatusError
        end
      end
  end
end