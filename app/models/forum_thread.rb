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
  include Status::ModelStatus
  include Search::StandardModelSearch
  
  attr_accessible :content_id, :description, :name, :url
  
  belongs_to :forum
  has_many :comments, :foreign_key => :thread_id, :autosave => true
  has_many :complaints, :through => :comments
  
  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 255 }
  validates :status, :presence => true
  validates :url, :length => { :maximum => 500 }
  validates :forum_id, :presence => true
  
  default_scope where("#{table_name}.status != #{find_status_value(:deleted)}")
  
  # Define configurations for status machine
  def_valid_status :active, :inactive, :deleted
  def_terminal_status :deleted
  def_initial_status_proc :init_status
  
  # Callback that allows to create subset for target_status depending on object state
  def_contraints_to_target_status :target_status_constraint
  
  # Define callbacks for status change actions
  def_before_status_change :inactive, :deleted, :exec_status_change
  
  # Define search configurations
  def_default_status_for_search :active
  def_default_search_fields :name, :description
  
  def_extended_search do |options|
    [{:query => "forum_id = :forum_id", :params => {:forum_id => options[:forum_id]}}] unless options[:forum_id].blank?
  end
  
  private
  
    def init_status
      return :inactive if !forum.nil? && !forum.active?
      :active
    end
    
    def exec_status_change(old_status, new_status, action)
      s = new_status
      s = :rejected if new_status == :inactive
      complaints.update_all(:status => find_status_value(s)) if new_status != :inactive
      comments.update_all(:status => find_status_value(s))
    end
    
    def target_status_constraint(status)
      return [:deleted] if !forum.nil? && !forum.active?
      status
    end
end
