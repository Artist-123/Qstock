class PasswordsController < ApplicationController
	skip_before_action :authenticate_request
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
  	
    user = User.find_by(email: params[:email])
    if user&.otp_valid?(params[:otp]) 
      render json: { message: 'OTP verified successfully' }, status: :ok
    else
      render json: { error: 'Invalid OTP or user' }, status: :unprocessable_entity
    end
  end


  def reset_password
    user = User.find_by(reset_token: params[:reset_token])
    if user&.reset_token_valid?
      user.update(password: params[:password]) 
      render json: { message: 'Password reset successfully' }, status: :ok
    else
      render json: { error: 'Invalid or expired reset token' }, status: :unprocessable_entity
    end
  end
end
