class PasswordsController < ApplicationController
	#skip_before_action :authenticate_request
	def forgot_password
    user = User.find_by(email: params[:email])
    if user
      user.generate_reset_token 
      OtpMailer.forgot_password_email(user).deliver_now 
      render json: { message: 'Password reset link sent successfully' }, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
   

def resend_otp

    user = User.find_by(email: params[:email])
    if user
      user.generate_and_assign_otp 
      OtpMailer.resend_otp_email(user).deliver_now 
      render json: { message: 'New OTP sent successfully' }, status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end


  
  	
   def verify_otp
   	byebug
    user = User.find_by(params[:email])
    if user&.otp_valid?(params[:otp])
      user.update(activated: true, otp: nil)
      render json: { message: 'User activated successfully' }
    else
      render json: { error: 'Invalid OTP or user' }, status: :unprocessable_entity
    end
  end


  def reset_password
     user = User.find_by(email: params[:email])

    if user
      # Generate and send reset token via email
      reset_token = SecureRandom.hex(20)
      user.update(reset_token: reset_token, reset_token_expires_at: 1.hour.from_now)

      # Send reset instructions via email
      UserMailer.reset_password_email(user, reset_token).deliver_now

      render json: { message: 'Password reset instructions sent successfully' }
    else
      render json: { error: 'User not found' }, status: :not_found
    end
end

private

  def generate_reset_token
    SecureRandom.hex(20)
  end
end