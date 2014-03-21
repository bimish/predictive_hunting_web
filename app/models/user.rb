class User < ActiveRecord::Base

	has_secure_password

	before_save	{	self.email.downcase! }
	before_save	{	self.authentication_method = 1 }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, presence:true, length: { maximum: 100 }
  validates :last_name, presence:true, length: { maximum: 100 }
  validates :email,
  	presence:true,
  	length: { maximum: 254 },
  	format: { with: VALID_EMAIL_REGEX },
  	uniqueness: { case_sensitive: false }
  validates :password, presence:true, length: { minimum: 6 }, if: ->(record) { record.new_record? || record.password.present? || password_confirmation.present?  }
  validates :password_confirmation, presence:true, if: ->(record) { record.new_record? || record.password_confirmation.present? || password.present?  }

private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
