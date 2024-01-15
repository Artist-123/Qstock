class CoursesController < ApplicationController
 load_and_authorize_resource
 def index
  courses = Course.all
  render json: courses, each_serializer: CourseSerializer
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
    render json: { course: CourseSerializer.new(course)}, status: :created
  else
    render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
  end
end

def purchase_course
  begin
    @course = Course.find_by(params[:id])
    @user = current_user
    @stripe_id = @user.stripe_id
    @card = StripeService.create_stripe_customer_card(@stripe_id)
    @charge = StripeService.create_on_stripe_charge(@course.price, @stripe_id, @card.id)
    render json:  @charge
      # payment_intent = stripe_service.create_payment_intent(@course, @user) 
      # render json: { message: 'Purchase successful!' }
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

  def purchase_course_params
   params.permit(:course_id, :stripe_token)
 end
 def course_params
  params.require(:course).permit(:title, :category, :price, :expert_id)
end
end
