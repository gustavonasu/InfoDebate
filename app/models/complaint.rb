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
  
  validates :body, :presence => true, :length => { :maximum => 4000 }
  validates :status, :presence => true
  validates :comment_id, :presence => true
  validates :user_id, :presence => true
  
  default_scope where("#{table_name}.status != #{find_status_value(:deleted)}")
  
  # Define configurations for status machine
  def_valid_status :approved, :rejected, :pending, :deleted
  def_un_target_status :pending
  def_terminal_status :deleted
  def_initial_status :approved
  
  # Define search configurations
  def_default_status_for_search :approved
  def_default_search_fields :body
  
  def_extended_search do |options|
    list = []
    list << {:query => "comment_id = :comment_id",
             :params => {:comment_id => options[:comment_id]}} unless options[:comment_id].blank?
     list << {:query => "user_id = :user_id",
              :params => {:user_id => options[:user_id]}} unless options[:user_id].blank?
     list
  end
end
