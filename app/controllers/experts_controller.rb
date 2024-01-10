class ExpertsController < ApplicationController
  def index
    experts = Expert.all
    render json: experts
  end

  def show
    expert = Expert.find_by(id: params[:id])
    if expert.present?
      render json: expert
    else
      render json: { error: 'Expert not found' }, status: :not_found
    end
  end

  def create
    expert = Expert.new(expert_params)
    if expert.save
      render json: expert, status: :created
    else
      render json: { error: 'Failed to create expert' }, status: :unprocessable_entity
    end
  end

  def update
    expert = Expert.find_by(id: params[:id])
    if expert
      if expert.update(expert_params)
        render json: expert
      else
        render json: { error: 'Failed to update expert' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Expert not found' }, status: :not_found
    end
  end

def expert_courses
     expert = Expert.find_by(id: params[:expert_id])
    if expert
      courses = expert.courses
      render json: courses
    else
      render json: { error: 'Expert not found' }, status: :not_found
    end
  end

  def destroy
    expert = Expert.find_by(id: params[:id])
    if expert
      expert.destroy
      render json: { message: 'Expert deleted successfully'}
    else
      render json: { error: 'Expert not found' }, status: :not_found
    end
  end

  private

  def expert_params
    params.require(:expert).permit(:name, :description, :expertise)
  end
end
