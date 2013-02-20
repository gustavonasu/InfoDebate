module ModelStatus 
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    
    def all_status; ModelStatus.all_status end    

    def invalid_status; all_status - valid_status end
    
    def target_status; valid_status - un_target_status - terminal_status end
    
    def find_action(status); ModelStatus.find_action(status)  end
    
    def def_valid_status(*valid_status)
      define_singleton_method :valid_status do
        valid_status
      end
      
      define_method :valid_status do
        valid_status
      end
    end
    
    def def_un_target_status(*un_target_status)
      define_singleton_method :un_target_status do
        un_target_status
      end
      
      define_method :un_target_status do
        un_target_status
      end
    end
    
    def def_terminal_status(*terminal_status)
      define_singleton_method :terminal_status do
        terminal_status
      end
      
      define_method :terminal_status do
        terminal_status
      end
    end
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
  def all_status; ModelStatus.all_status end
  
  def invalid_status; self.class.invalid_status end
  
  def target_status; self.class.target_status end
  
  def self.find_action(status); STATUS_ACTION_MAP[status.to_sym] end  
  def find_action(status); ModelStatus.find_action(status) end
  
  def do_active!
    do_active
    save!
  end
  alias_method :active!, :do_active!
  
  def do_active
    send(:status=, :active)
  end
  alias_method :active, :do_active
  
  def active?
    :active == status
  end
  
  
  def do_inactive!
    do_inactive
    save!
  end
  alias_method :inactive!, :do_inactive!
  
  def do_inactive
    send(:status=, :inactive)
  end
  alias_method :inactive, :do_inactive
  
  def inactive?
    :inactive == status
  end
  
  
  def do_ban!
    do_ban
    save!
  end
  alias_method :ban!, :do_ban!
  
  def do_ban
    send(:status=, :banned)
  end
  alias_method :ban, :do_ban
  
  def banned?
    :banned == status
  end
  
  
  def do_pending!
    do_pending
    save!
  end
  alias_method :pending!, :do_pending!
  
  def do_pending
    send(:status=, :pending)
  end
  alias_method :pending, :do_pending
  
  def pending?
    :pending == status
  end
  
  
  def do_delete!
    do_delete
    save!
  end
  alias_method :delete!, :do_delete!
  
  def do_delete
    send(:status=, :deleted)
  end
  alias_method :delete, :do_delete

  def deleted?
    :deleted == status
  end
  
  # Disable destroy object
  def destroy
    do_delete!
  end
  
  def status
    STATUS.key(read_attribute(:status))
  end
  
  private

    def status=(s)
      raise InvalidStatus unless valid_status? s
      write_attribute :status, STATUS[s]
    end
    
    def valid_status?(s)
      return self.valid_status.count(s) > 0
    end
end