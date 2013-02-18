# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text(4000)
#  forum_id   :integer          not null
#  user_id    :integer          not null
#  status     :integer          not null
#  dislike    :integer          default(0)
#  like       :integer          default(0)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  include ModelStatus
  
  attr_accessible :body, :dislike, :like
  
  belongs_to :thread, :class_name => "ForumThread"
  belongs_to :user
  
  validates :body, :presence => true, :length => { :maximum => 4000 }
  validates :status, :presence => true
  validates :user_id, :presence => true
  validates :thread_id, :presence => true
  
  default_scope where("status != #{STATUS[:deleted]}")
  
  after_initialize do
    self.active if new_record? # default status is active
  end
  
  def self.valid_status
    [:active, :inactive, :pending, :banned, :deleted]
  end
end
