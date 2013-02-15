module ModelStatus 
  
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
    
    def self.all_status
      STATUS_ACTION_MAP.keys
    end
    
    def self.find_action(status)
      STATUS_ACTION_MAP[status.to_sym]
    end
    
    def active
      send(:status=, :active)
    end

    def active?
      :active == status
    end

    def inactive
      send(:status=, :inactive)
    end

    def inactive?
      :inactive == status
    end
    
    def ban
      send(:status=, :banned)
    end
    
    def banned?
      :banned == status
    end
    
    def pending
      send(:status=, :pending)
    end
    
    def pending?
      :pending == status
    end
    
    def delete
      send(:status=, :deleted)
    end

    def deleted?
      :deleted == status
    end
    
    # Disable destroy object
    def soft_destroy
      self.delete
      self.save
    end
    
    alias_method :destroy, :soft_destroy
    
    def status
      STATUS.key(read_attribute(:status))
    end
    
    private

      def status=(s)
        raise InvalidStatus unless valid_status? s
        write_attribute :status, STATUS[s]
      end
      
      def valid_status?(s)
        return self.class.valid_status.count(s) > 0
      end
end