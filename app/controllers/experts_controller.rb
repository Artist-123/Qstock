class ExpertsController < ApplicationController
	 load_and_authorize_resource
  before_action :set_expert, only: [:show, :update, :destroy]


  
  def index
    @experts = Expert.all
    render json: @experts
  end

 
  def show
    render json: @expert
  end

 
  def create
    @expert = Expert.new(expert_params)
    if @expert.save
      render json: @expert, status: :created
    else
      render json: @expert.errors, status: :unprocessable_entity
    end
  end

 
  def update
    if @expert.update(expert_params)
      render json: @expert
    else
      render json: @expert.errors, status: :unprocessable_entity
    end
  end

  
  def destroy
    @expert.destroy
   render json: { message: 'Expert deleted successfully' }, status: :ok
  end

  private

  def set_expert
    @expert = Expert.find(params[:id])
  end

  def expert_params
    params.require(:expert).permit(:name, :expertise, :description)
  end
end
