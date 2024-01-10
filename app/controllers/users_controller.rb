class UsersController < ApplicationController
	 #skip_before_action :authenticate_request, only: [:create]
      before_action :set_user, only: [:show, :update, :destroy]

      def index
        @users = User.all
        render json: @users
      end

      def show
        render json: @user
      end

      
      def create
      	
        @user = User.new(user_params)

        if @user.save
        	OtpMailer.otp_mail(@user).deliver_now
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

     
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
        #head :no_content
        render json: { message: 'User deleted successfully' }, status: :ok
      end

      private

     
      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :not_found
      end

      def user_params
        params.require(:user).permit(:username, :email, :password, :mobile_no, :role, :name)
      end
    end
 
