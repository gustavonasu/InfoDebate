module Status
  module ModelStatus 
  
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    STATUS = { :active => 1,
               :inactive => 2,
               :banned => 3,
               :pending => 4,
               :deleted => 5 }
    
    STATUS_ACTION_MAP = { :active => :active,
                          :inactive => :inactive,
                          :banned => :ban,
                          :pending => :pending,
                          :deleted => :delete }
    
    def self.all_status; STATUS.keys end
    def self.find_action(status); STATUS_ACTION_MAP[status.to_sym] end
    def self.find_status_value(status); STATUS[status.to_sym] end 
    def self.find_status(value); STATUS.key(value) end
    
    # Metodos de instância relacionados a lista de status
    def all_status; self.class.all_status end
    def valid_status; self.class.valid_status end
    def invalid_status; self.class.invalid_status end
    def target_status; self.class.target_status end
    def un_target_status; self.class.un_target_status end
    def terminal_status; self.class.terminal_status end
    def status; find_status(read_attribute(:status)) end
    
    # Metodos helper de instância
    def find_action(status); self.class.find_action(status) end
    def find_status_value(status); self.class.find_status_value(status) end
    def find_status(value); self.class.find_status(value) end
    
    # Metodos de instância alteração de status
    ModelStatus.all_status.each do |s|
      action = find_action(s)
      define_method "do_#{action}" do
        send(:status=, s)
      end
      alias_method "#{action}", "do_#{action}"
    
      define_method "do_#{action}!" do
        send("do_#{action}")
        save!
      end
      alias_method "#{action}!", "do_#{action}!"
    
      define_method "#{s}?" do
        s == status
      end
    end
    
    # Disable destroy object
    def destroy; do_delete! end
    
    private

      def status=(s)
        raise InvalidStatus unless valid_status? s
        write_attribute :status, find_status_value(s)
      end
    
      def valid_status?(s)
        return self.valid_status.count(s) > 0
      end
  end
end