class CoursesController < ApplicationController
  #before_action :set_expert
  before_action :set_course, only: [:show, :update, :destroy]
  # load_and_authorize_resource

  
  def index
    @courses = Course.all
    render json: @courses
  end

  
  def show
    render json: @course
  end

  #  def purchase_course
   	
   
  #   course = Course.find(params[:id])
  #   user = current_user

  #   begin
  #     charge = Stripe::Charge.create(
  #       amount: course.price * 100, # Convert price to cents
  #       currency: 'usd',
  #       source: params[ 
  #        ::credit_card_number => "4242424242424242",
  #     ::credit_card_exp_month => "10",
  #     ::credit_card_exp_year => "2028",
  #     ::credit_card_cvv => "1234"], 
  #       description: "Purchase of #{course.title}" 
  #     )

     
  #     Payment.create(
  #       user_id: "1",
  #       course_id: "1",
  #       amount: 320,
  #       transaction_id: 1 
       

  #     render json: { message: 'Course purchased successfully' }, status: :ok
  #   rescue Stripe::CardError => e
     
  #     render json: { error: e.message }, status: :unprocessable_entity
  #   end
  # end end
 

  def create
  	
    @course = Course.new(course_params)
    if @course.save
      render json: @course, status: :created
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

 
  def update
    if @course.update(course_params)
      render json: @course
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  
  def destroy
    @course.destroy
    head :no_content
  end

  private

  def set_expert
    @expert = Expert.find(params[:expert_id])
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :category, :price, :expert_id)
  end
end
