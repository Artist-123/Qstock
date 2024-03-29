class UsersController < ApplicationController
	skip_before_action :authenticate_request, only: [:create, :index, :show, :update, :destroy]
	
	def index
		@users = User.all
		render json: @users
	end

	def show
		@user = User.find(params[:id])
		render json: @user
	end

	
	def create
		
		@user = User.new(user_params)
		StripeService.find_or_create_customer(@user)
		if @user.save
			OtpMailer.otp_mail(@user).deliver_now
			render json: { user: @user, otp: @user.otp }, status: :created
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end


	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			render json: @user
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy

		render json: { message: 'User deleted successfully' }, status: :ok
	end

	private

	def user_params
		params.require(:user).permit(:email, :password, :mobile_no, :role, :name)
	end
end

