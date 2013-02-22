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
  include Status::ModelStatus
  extend StandardModelSearch
  
  attr_accessible :description, :name

  has_many :threads, :class_name => "ForumThread", :autosave => true

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 255 }
  validates :status, :presence => true
  
  default_scope where("status != #{find_status_value(:deleted)}")
  
  # Define configurações de status
  def_valid_status :active, :inactive, :deleted
  def_terminal_status :deleted
  def_initial_status :active
    
  # Define callbacks para alteração de status
  def_before_status_change :inactive, :deleted, :exec_status_change
  
  
  def self.term_search_fields
    [:name, :description]
  end
  
  private
    def exec_status_change(action)
      threads.each {|thread| thread.send(action) }
    end
end
