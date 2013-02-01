class ForumThread < ActiveRecord::Base
  include Infodebate::Status
  
  attr_accessible :content_id, :description, :name, :url
  
  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 255 }
  validates :status, :presence => true
  validates :url, :length => { :maximum => 500 }
  
  after_initialize do
    self.active # default status is active
  end
  
  def self.valid_status
    [:active, :inactive, :deleted]
  end
  
end
