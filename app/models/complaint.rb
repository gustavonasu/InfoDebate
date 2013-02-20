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
  include ModelStatus
  extend StandardModelSearch
    
  attr_accessible :body
  
  belongs_to :comment
  belongs_to :user
  
  validates :body, :presence => true, :length => { :maximum => 4000 }
  validates :status, :presence => true
  validates :comment_id, :presence => true
  validates :user_id, :presence => true
  
  default_scope where("status != #{STATUS[:deleted]}")
  
  # Define configurações de status
  def_valid_status :active, :inactive, :pending, :deleted
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
    unless options[:comment_id].blank?
      query = "comment_id = :comment_id"
      query_params = {:comment_id => options[:comment_id]}
    end
    unless options[:user_id].blank?
      query = append_query(query, "user_id = :user_id")
      query_params.merge!(:user_id => options[:user_id])
    end
    [query, query_params] 
  end
  
end
