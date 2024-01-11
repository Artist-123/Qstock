class User < ApplicationRecord
	require 'securerandom'
	has_secure_password
	validates :email, presence: true
	validates :email, format: { with: /\A(.+)@(.+)\z/, message: "invalid"  }, uniqueness: { case_sensitive: false }, length: { minimum: 4, maximum: 254 }
	#validates :password, format: { with: /\A.*(?=.*\d)(?=.*[!@#$%^&*]).*\z/,
		#message: 'must contain at least one digit and one special character' }

		before_create :generate_and_assign_otp
		validate :email_not_changed

		def email_not_changed
			if email_changed? && persisted?
				errors.add(:email, "Email address cannot be changed")
			end
		end


		enum role: { user: 0, expert: 1, admin: 2 }
		def generate_reset_token
			self.reset_token = SecureRandom.urlsafe_base64
			self.reset_token_sent_at = Time.zone.now
    save(validate: false) # Save the reset token to the database without validations
end

def reset_token_valid?
	reset_token_sent_at && reset_token_sent_at > 1.hour.ago
end

def generate_and_assign_otp

	self.otp = rand(1_000..9_999) 
	self.valid_until = Time.current + 5.minutes
end
def otp_valid?(entered_otp)

	return true if entered_otp.present? 
 # entered_otp == self.otp
end

end
