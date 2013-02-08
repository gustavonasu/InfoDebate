# == Schema Information
#
# Table name: users
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

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :username, :email, :password, :password_confirmation
  attr_readonly :username
  
  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :username, :presence => true, :length => { :in => 3..30 },
                       :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true,
                    :email => true,
                    :uniqueness => { :case_sensitive => false }
  validates :password, :length => { :in => 6..40 },
                       :confirmation => true, :if => :validate_password?
  
  before_validation :fix_password_validation, :encrypt_password
  
  def self.authenticate(username, submitted_password)
    user = first(:conditions => {:username => username})
    return user if user.has_password(submitted_password)
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
      new_record? ||
      (!new_record? && !password.blank?)
    end
    
    def fix_password_validation
      # password_confirmation when nil doesn't validate
      if !password.blank? && self.password_confirmation.blank?
        self.password_confirmation = ""
      end
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
