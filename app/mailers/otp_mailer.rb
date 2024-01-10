class OtpMailer < ApplicationMailer
	def otp_mail(user)
		@user = user
		mail(to: @user.email, subject: "Welcome, #{@user.name}")
	end
	def forgot_password_email(user)
    @user = user
    @reset_link = "https://yourapp.com/reset_password?token=#{user.reset_token}"
    mail(to: @user.email, subject: 'Reset Your Password')
  end

  def resend_otp_email(user)
    @user = user
    @new_otp = @user.otp
    mail(to: @user.email, subject: 'Your New OTP')
  end
end
