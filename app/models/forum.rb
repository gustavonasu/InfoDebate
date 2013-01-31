class Forum < ActiveRecord::Base
  include Infodebate::Status
  
  attr_accessible :description, :name

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 255 }
  validates :status, :presence => true
  
  def self.valid_status
    [:active, :inactive, :deleted]
  end
  
  def initialize(attributes = {})
    super(attributes)
    self.active # default status is active
  end
  
end
