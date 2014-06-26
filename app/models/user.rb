class User < ActiveRecord::Base
  has_many :microposts
  before_save { email.downcase! }
  before_create :create_remember_token

  #validations
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  #class methods
  # def User.new_remember_token
  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # def User.digest(token)
  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s) #call .to_s to handle test cases in which token is nil
  end

  #private methods
  private
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
