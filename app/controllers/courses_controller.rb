class CoursesController < ApplicationController
 #load_and_authorize_resource
    def index
    courses = Course.all
    render json: courses
  end

  def show
    course = Course.find_by(id: params[:id])
    if course
      render json: course
    else
      render json: { error: 'Course not found' }, status: :not_found
    end
  end
 
  def create
    course = Course.new(course_params)
    if course.save
      render json: course, status: :created
    else
      render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
    end
  end

   def purchase_course
   	byebug
    course = Course.find_by(id: params[:course_id])

    unless course
      render json: { error: 'Course not found' }, status: :not_found
      return
    end

    user = @current_user # Assuming you have a method to get the current user (e.g., using Devise)

    if user.purchased_courses.include?(course)
      render json: { error: 'Course already purchased' }, status: :unprocessable_entity
      return
    end

    # Stripe Payment Processing
    begin
      charge = Stripe::Charge.create(
        amount: course.price * 100, # Stripe requires amount in cents
        currency: 'usd',
        source: params[:stripe_token], # Token obtained from the frontend using Stripe.js or Elements
        description: "Purchase of #{course.title}"
      )

      if charge.status == 'succeeded'
        # Save the purchase in your database
        Purchase.create(user: user, course: course)

        render json: { message: 'Course purchased successfully' }, status: :ok
      else
        render json: { error: 'Payment failed' }, status: :unprocessable_entity
      end
    rescue Stripe::CardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
 
  def update
    course = Course.find_by(id: params[:id])
    if course&.update(course_params)
      render json: course
    else
      render json: { errors: ['Course not found or unable to update'] }, status: :unprocessable_entity
    end
  end

  def destroy
    course = Course.find_by(id: params[:id])
    if course&.destroy
      render json: { message: 'Course deleted successfully'}
    else
      render json: { errors: ['Course not found or unable to delete'] }, status: :unprocessable_entity
    end
  end
	
  private

  
  def course_params
    params.require(:course).permit(:title, :category, :price, :expert_id)
  end
end
