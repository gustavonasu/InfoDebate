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
  include Search::StandardModelSearch
  
  attr_accessible :description, :name

  has_many :threads, :class_name => "ForumThread", :autosave => true

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 255 }
  validates :status, :presence => true
  
  default_scope where("#{table_name}.status != #{find_status_value(:deleted)}")
  
  # Define configurations for status machine
  def_valid_status :active, :inactive, :deleted
  def_terminal_status :deleted
  def_initial_status :active
    
  # Define callbacks for status change actions
  def_before_status_change :inactive, :deleted, :exec_status_change
  
  # Define search configurations
  def_default_status_for_search :active
  def_default_search_fields :id => :integer, :name => :string, :description => :string
  
  private
    def exec_status_change(old_status, new_status, action)
      threads.each {|thread| thread.send(action) }
    end
end
