# == Schema Information
#
# Table name: forum_threads
#
#  id          :integer          not null, primary key
#  name        :string(100)      not null
#  description :string(255)
#  url         :string(500)
#  status      :integer          not null
#  content_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  forum_id    :integer          not null
#

class ForumThread < ActiveRecord::Base
  include ModelStatus
  
  attr_accessible :content_id, :description, :name, :url
  
  belongs_to :forum
  
  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 255 }
  validates :status, :presence => true
  validates :url, :length => { :maximum => 500 }
  validates :forum_id, :presence => true
  
  
  after_initialize do
    self.active if new_record? # default status is active
  end
  
  def self.valid_status
    [:active, :inactive, :deleted]
  end
  
end
