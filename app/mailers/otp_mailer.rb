class OtpMailer < ApplicationMailer
	def otp_mail(user)
		@user = user
		mail(to: @user.email, subject: "Welcome, #{@user.name}")
	end


	def forgot_password_email(user, token, otp)
    @user = user
    @user.generate_reset_password_token 
    @reset_link = "https://yourapp.com/reset_password?token=#{token}"
    @token = token
    @otp = otp
    mail(to: @user.email, subject: 'Reset Your Password')
  end


  def resend_otp_email(user)
    @user = user
    @new_otp = @user.otp
    mail(to: @user.email, subject: 'Your New OTP')
  end

  
  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'Password updated successfully')
  end
end
