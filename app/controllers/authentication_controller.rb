class AuthenticationController < ApplicationController
	skip_before_action :authenticate_request
	def login
	
		user = User.find_by_email(params[:email])
		
		
		if user.present? && user.activated?
			if user.authenticate(params[:password])
				token = jwt_encode(user_id: user.id)
				render json: { token: token, user: user }, status: :ok
			else
				render json: { error: 'unauthorized' }, status: :unauthorized
			end
		else
			render json: { error: 'unauthorized' }, status: :unauthorized
		end
	end
end
