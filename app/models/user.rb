class User < ApplicationRecord
	require 'securerandom'
	has_secure_password
	validates :email, presence: true
    validates :email, format: { with: /\A(.+)@(.+)\z/, message: "invalid"  }, uniqueness: { case_sensitive: false }, length: { minimum: 4, maximum: 254 }
    validates :password, format: { with: /\A.*(?=.*\d)(?=.*[!@#$%^&*]).*\z/,
    message: 'must contain at least one digit and one special character' }
    before_create :generate_and_assign_otp
    attr_accessor :otp
    attr_accessor :reset_token
    attr_accessor :reset_token_sent_at
    enum role: { user: 0, expert: 1, admin: 2 }
 def generate_reset_token
    self.reset_token = SecureRandom.urlsafe_base64
    self.reset_token_sent_at = Time.zone.now
    save(validate: false) # Save the reset token to the database without validations
  end

  def reset_token_valid?
    reset_token_sent_at && reset_token_sent_at > 1.hour.ago
  end
 after_initialize :set_default_role, if: :new_record?
  # set default role to user  if not set
  def set_default_role
    self.role ||= :user
  end

  def generate_and_assign_otp
    self.otp = '%04d' % SecureRandom.random_number(10_000) # Generating a 3-digit OTP (you can adjust the length)
  end
   def otp_valid?(otp)
    return false if otp.blank? || self.otp.blank?
    otp == self.otp
  end
end
