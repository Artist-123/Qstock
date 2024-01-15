class AuthenticationController < ApplicationController
	skip_before_action :authenticate_request, only: [:login, :logout]
	def login
		user = User.find_by(email: params[:email])

		if user&.activated? && user.authenticate(params[:password])
			token = jwt_encode(user_id: user.id)
			render json: { token: token, user: user }, status: :ok
		else
			render json: { error: 'Invalid email, password, or user not activated' }, status: :unauthorized
		end
	end

	def logout
		user = User.find_by(email: params[:email])

		if user.present? && user.activated?
     # token = jwt_encode(user_id: user.id)
     user.delete
     render json: { message: 'User logged out successfully' }, status: :ok
 else
 	render json: { error: 'Invalid user or user not activated' }, status: :unprocessable_entity
 end
end

end
