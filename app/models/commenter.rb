# == Schema Information
#
# Table name: commenters
#
#  id                 :integer          not null, primary key
#  name               :string(100)      not null
#  username           :string(30)       not null
#  email              :string(255)      not null
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Commenter < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :username, :email, :password, :password_confirmation
  
  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :username, :presence => true, :length => { :in => 3..30 },
                       :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true,
                    :email => true,
                    :uniqueness => { :case_sensitive => false }
  validates :password, :length => { :in => 6..40 },
                       :confirmation => true, :if => :validate_password?
  
  before_validation :encrypt_password
  
  def username=(value)
    if new_record?
      self[:username] = value
    else
      raise "You can't change login"
    end
  end
  
  def self.authenticate(username, submitted_password)
    commenter = first(:conditions => {:username => username})
    return commenter if commenter.has_password(submitted_password)
  end
  
  def has_password(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end
  
  def self.search(search, page)
    s = "%#{search}%"
    paginate :per_page => PER_PAGE, :page => page,
             :conditions => ['name like ? or username like ? or email like ?', s, s, s]
  end
  
  private
    
    def validate_password?
      !password.blank? || new_record?
    end
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password) unless password.blank?
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
