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
  include ModelStatus
  extend StandardModelSearch
  
  attr_accessible :content_id, :description, :name, :url
  
  belongs_to :forum
  has_many :comments
  
  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :description, :length => { :maximum => 255 }
  validates :status, :presence => true
  validates :url, :length => { :maximum => 500 }
  validates :forum_id, :presence => true
  
  default_scope where("status != #{STATUS[:deleted]}")
  
  # Define configurações de status
  def_valid_status :active, :inactive, :deleted
  def_un_target_status :pending
  def_terminal_status :deleted
  
  after_initialize do
    self.active if new_record? # default status is active
    update_status(forum)
  end
  
  
  alias_method :original_forum=, :forum=
  def forum=(new_forum)
    update_status(new_forum)
    self.original_forum = new_forum
  end
  
  
  def self.term_search_fields
    [:name, :description]
  end
  
  def self.extended_search(options)
    ["forum_id = :forum_id", {:forum_id => options[:forum_id]}] unless options[:forum_id].blank?
  end
  
  private
  
    def update_status(forum)
      self.inactive if !forum.nil? && !forum.active?
    end
end
