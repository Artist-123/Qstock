 class ApplicationController < ActionController::Base
 	protect_from_forgery with: :null_session, if: -> { request.format.json? }
 	include JsonWebToken

 	before_action :authenticate_request
 	 rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json{ render json: { error: 'Access Denied - You are not authorized to perform this action' }, status: :forbidden }
      
    end
  end


 	private

 	def authenticate_request
 		header = request.headers["token"]
 		header = header.split(" ").last if header
 		@decoded = jwt_decode(header)
 		def current_user
 			@current_user = User.find(@decoded[:user_id]) 
 		end
 	end
 end
