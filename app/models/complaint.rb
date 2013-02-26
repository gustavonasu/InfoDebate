# == Schema Information
#
# Table name: complaints
#
#  id         :integer          not null, primary key
#  comment_id :integer
#  body       :string(4000)
#  status     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Complaint < ActiveRecord::Base
  include Status::ModelStatus
  include Search::StandardModelSearch
    
  attr_accessible :body
  
  belongs_to :comment
  belongs_to :user
  
  has_one :thread, :class_name => "ForumThread", :through => :comment
  
  validates :body, :presence => true, :length => { :maximum => 4000 }
  validates :status, :presence => true
  validates :comment_id, :presence => true
  validates :user_id, :presence => true
  
  default_scope where("#{table_name}.status != #{find_status_value(:deleted)}")
  
  # Define configurations for status machine
  def_valid_status :approved, :rejected, :pending, :deleted
  def_un_target_status :pending
  def_terminal_status :deleted
  def_initial_status_proc :init_status
  
  # Define callbacks for status change actions
  def_before_status_change :approved, :reject_comment
  
  # Define search configurations
  def_default_status_for_search :pending
  def_default_search_fields :id => :integer, :comment_id => :integer, :body => :string
  def_joins_for_search :comment, :thread
  
  def_extended_search do |options|
    list = []
    list << {:query => "#{table_name}.user_id = :user_id",
              :params => {:user_id => options[:user_id]}} unless options[:user_id].blank?
    list << {:query => "comments.thread_id = :thread_id",
             :params => {:thread_id => options[:thread_id]}} unless options[:thread_id].blank?
    list << {:query => "forum_threads.forum_id = :forum_id",
             :params => {:forum_id => options[:forum_id]}} unless options[:forum_id].blank?
    list
  end
  
  private
  
    def init_status
      raise CreationModelError, I18n.t(:not_active_user, :scope => :model_creation) if (!user.nil? && !user.active?)
      return :rejected if (!comment.nil? && !comment.approved?)
      :pending
    end
    
    def reject_comment(old_status, new_status, action)
      comment.reject! if !comment.nil? && comment.approved?
    end
end
