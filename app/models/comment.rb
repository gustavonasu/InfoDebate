# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :string(4000)
#  thread_id  :integer          not null
#  user_id    :integer          not null
#  status     :integer          not null
#  dislike    :integer          default(0)
#  like       :integer          default(0)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  include Status::ModelStatus
  include Search::StandardModelSearch
    
  attr_accessible :body, :dislike, :like
  
  belongs_to :thread, :class_name => "ForumThread"
  belongs_to :user
  
  has_many :complaints, :autosave => true
  
  validates :body, :presence => true, :length => { :maximum => 4000 }
  validates :status, :presence => true
  validates :user_id, :presence => true
  validates :thread_id, :presence => true
  
  default_scope where("#{table_name}.status != #{find_status_value(:deleted)}")
  
  # Define configurations for status machine
  def_valid_status :approved, :rejected, :pending, :spam, :deleted
  def_un_target_status :pending
  def_terminal_status :deleted
  def_initial_status :approved
  
  # Define callbacks for status change actions
  def_before_status_change :deleted, :exec_status_change
  
  # Define search configurations
  def_default_status_for_search :approved
  def_default_search_fields :body
  
  def_extended_search do |options|
    list = []
    list << {:query => "thread_id = :thread_id",
             :params => {:thread_id => options[:thread_id]}} unless options[:thread_id].blank?
    list << {:query => "user_id = :user_id",
              :params => {:user_id => options[:user_id]}} unless options[:user_id].blank?
    list
  end
  
  private
    def exec_status_change(old_status, new_status, action)
      complaints.update_all(:status => find_status_value(new_status))
    end
end
