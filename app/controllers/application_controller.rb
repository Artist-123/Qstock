# class ApplicationController < ActionController::Base
# 	 protect_from_forgery with: :null_session, if: -> { request.format.json? }
# 	include JsonWebToken
# 	before_action :authenticate_request
# 	 private
# 	  def authenticate_request
# 	  	byebug
# 	  	header = request.headers["Authrization"]
# 	  	if header.present?
# 	  	token = header.split(" ")[1]
# 	  	begin
# 	  	decoded = jwt_decode(token)
# 	  	@current_user = User.find(decoded[0][:user_id])
# 	  # else
# 	  # 	  render json: { error: 'Unauthorized access' }, status: :unauthorized
# 	  # end
# 	  rescue JWT::DecodeError
#     render json: { error: 'Invalid token' }, status: :unauthorized
#   end
# end
  

  class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  include JsonWebToken

  before_action :authenticate_request

  private

  def authenticate_request
  	 byebug
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    @decoded = jwt_decode(header)
    def current_user
    @current_user = User.find(@decoded[:user_id]) 
    end
  end
end
