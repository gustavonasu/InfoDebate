# == Schema Information
#
# Table name: forums
#
#  id          :integer          not null, primary key
#  name        :string(100)      not null
#  description :string(255)
#  status      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Forum < ActiveRecord::Base
  include ModelStatus
  extend StandardModelSearch
  
  attr_accessible :description, :name

  has_many :threads, :class_name => "ForumThread"

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 255 }
  validates :status, :presence => true
  
  default_scope where("status != #{STATUS[:deleted]}")
  
  after_initialize do
    self.active if new_record? # default status is active
  end
  
  def self.valid_status
    [:active, :inactive, :deleted]
  end
  
  def destroy
    exec_delete "do_delete!"
  end
  alias_method :delete!, :destroy
  
  def delete
    exec_delete "do_delete"
  end
  
  private
    def exec_delete(action)
      Forum.transaction do
        send(action)
        threads.each {|thread| thread.send(action) }
      end
    end
end
