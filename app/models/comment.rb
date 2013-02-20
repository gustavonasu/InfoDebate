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
  extend StandardModelSearch
    
  attr_accessible :body, :dislike, :like
  
  belongs_to :thread, :class_name => "ForumThread"
  belongs_to :user
  
  has_many :complaints
  
  validates :body, :presence => true, :length => { :maximum => 4000 }
  validates :status, :presence => true
  validates :user_id, :presence => true
  validates :thread_id, :presence => true
  
  default_scope where("status != #{find_status_value(:deleted)}")
  
  # Define configurações de status
  def_valid_status :active, :inactive, :pending, :banned, :deleted
  def_un_target_status :pending
  def_terminal_status :deleted
  
  after_initialize do
    self.active if new_record? # default status is active
  end
  
  def self.term_search_fields
    [:body]
  end
  
  def self.extended_search(options)
    query = ""
    query_params = {}
    unless options[:thread_id].blank?
      query = "thread_id = :thread_id"
      query_params = {:thread_id => options[:thread_id]}
    end
    unless options[:user_id].blank?
      query = append_query(query, "user_id = :user_id")
      query_params.merge!(:user_id => options[:user_id])
    end
    [query, query_params] 
  end
end
