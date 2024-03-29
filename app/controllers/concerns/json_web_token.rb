require 'jwt'
module JsonWebToken
	extend ActiveSupport::Concern
	SECRET_KEY = Rails.application.secret_key_base

	def jwt_encode(payload, exp = 7.days.from_now)
		
		payload[:exp] = exp.to_i
		JWT.encode(payload, SECRET_KEY)
	end

	def jwt_decode(token)

		decoded = JWT.decode(token, SECRET_KEY)[0]
		HashWithIndifferentAccess.new decoded
	rescue JWT::DecodeError => e
		logger.error "JWT Decode Error: #{e.message}"
		render json: { error: 'Invalid or expired token' }, status: :unprocessable_entity
	rescue JSON::ParserError => e
		logger.error "Missing required parameters: #{e.message}"
		render json: { error: 'Invalid JSON format' }, status: :unprocessable_entity
	end
end


























