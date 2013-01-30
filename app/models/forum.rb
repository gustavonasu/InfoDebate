class Forum < ActiveRecord::Base
  attr_accessible :description, :name

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 255 }
  validates :status, :presence => true
  
  STATUS = { actived: 1, inactived: 2, deleted: 3 }
  
  
  def initialize(attributes = {})
    super(attributes)
    self.active # default status is active
  end
  
  def active
    send(:status=, :actived)
  end
  
  def actived?
    :actived == send(:status)
  end

  def inactive
    send(:status=, :inactived)
  end
  
  def inactived?
    :inactived == send(:status)
  end
  
  def delete
    send(:status=, :deleted)
  end
  
  def deleted?
    :deleted == send(:status)
  end
  
  private 
    
    def status
      STATUS.key(read_attribute(:status))
    end
    
    def status=(s)
      write_attribute :status, STATUS[s]
    end
end
