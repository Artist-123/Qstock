class User < ApplicationRecord
	require 'securerandom'
	has_secure_password
	has_many :purchases
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

		before_create :generate_reset_password_token


		Max_Otp_Attempts = 10
		Otp_Attempt_Expiry = Time.now.beginning_of_day


		def can_attempt_otp?

			if otp_attempts <= Max_Otp_Attempts
				self.update(otp_attempts: otp_attempts + 1, last_otp_attempt: Time.now)
			elsif last_otp_attempt.present? && last_otp_attempt > Time.now - Otp_Attempt_Expiry
				return false
			end

			true
		end


		def generate_reset_password_token
			self.reset_password_token = SecureRandom.urlsafe_base64
		end

		def generate_reset_token
			self.reset_token = SecureRandom.urlsafe_base64
			self.reset_token_sent_at = Time.zone.now
		end

		def self.reset_password_token_valid?(token)
			reset_password_token_sent_at && reset_password_token_sent_at > 1.hour.ago
		end

		def token_valid?
			(self.reset_password_sent_at + 4.hours) > Time.now
		end

		def reset_password(user)
			@user = user
			mail(to: @user.email, subject: 'Reset your password')
		end

		def generate_and_assign_otp

			self.otp = rand(1_000..9_999) 
			self.valid_until = Time.current + 5.minutes
        		#self.otps.create(pin: otp, attempted_at: Time.now)
        	end
        	def otp_valid?(entered_otp)
        		user.reset_password_otp == otp && user.reset_password_otp_sent_at < 5.minutes.ago
        		return true if entered_otp.present? && Time.now
        	end
        end

