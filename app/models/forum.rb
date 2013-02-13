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
  
  def self.search(term, page = 1, per_page = PER_PAGE)
    query = '(upper(name) like upper(:term) or upper(description) like upper(:term))'
    query_params = {:term => (term.blank? ? "" : "%#{term}%")}
    paginate :per_page => per_page, :page => page,
                      :conditions => [query, query_params]
  end
  
  def self.search_by_name(term, page = 1, per_page = PER_PAGE)
    s = term.blank? ? "" : "%#{term}%"
    paginate :per_page => per_page, :page => page,
             :conditions => ['upper(name) like upper(?)', s]
  end

end
