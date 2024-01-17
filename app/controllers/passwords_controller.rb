class PasswordsController < ApplicationController
 skip_before_action :authenticate_request, only: [:forgot_password, :resend_otp, :verify_otp, :reset_password]

 def forgot_password
   user = User.find_by(email: params[:email])
  token = jwt_encode(user_id: user.id)
  otp =user.generate_and_assign_otp
  if user.update(reset_password_otp: otp, reset_password_otp_sent_at: Time.now)
  #if user.update(reset_password_token: token, reset_password_token_sent_at: Time.now)
    OtpMailer.forgot_password_email(user, token, otp).deliver_now 
    render json: { message: 'Password reset instructions sent to your email', reset_password_otp: user.otp , reset_password_token: token }, status: :ok
 else
    render json: { error: 'User not found' }, status: :not_found
 end
end


def resend_otp
  user = User.find_by(email: params[:email])
  if user.present?
    user.generate_and_assign_otp 
    OtpMailer.resend_otp_email(user).deliver_now 
    render json: { message: 'New OTP sent successfully', otp: user.otp }, status: :ok
 else
    render json: { error: 'User not found' }, status: :not_found
 end
end


def verify_otp
   user = User.find_by(email: params[:verify_otp][:email])
   if user.present? && user.otp_valid?(params[:verify_otp][:otp])
    user.update!(activated: true) 

    render json: { message: 'OTP verified and account activated successfully. You can now log in.' }
 else
    render json: { error: 'Invalid OTP or user' }, status: :unprocessable_entity
 end
end


def reset_password
  # token = params[:token]
  otp = params[:otp]
  user = User.find_by(email: params[:email])
  byebug
   #if token_valid(user) & user.reset_password_token == token && user.otp_valid?(user) & user.reset_password_otp == otp
   if  user.otp == otp.to_i && Time.now < user.valid_until 
   # if otp_valid?(user)
    new_password = params[:new_password]

    if new_password.present?
       user.update(password: new_password, otp: nil)


       OtpMailer.reset_password_email(user).deliver_now

       render json: { message: 'Password updated successfully', password: new_password }, status: :ok
    else
     render json: { error: 'New password is required' }, status: :unprocessable_entity
  end
else
 render json: { error: 'Invalid or expired otp' }, status: :unprocessable_entity
end
end

def token_valid(user)

   user.reset_password_token_sent_at > 1.hour.ago
end
end

