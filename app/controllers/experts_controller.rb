class ExpertsController < ApplicationController
	def index
		experts = Expert.all
		render json: experts.as_json(only: [:id], methods: [:profile_picture])
	end

	def show
		expert = Expert.find_by(id: params[:id])
		if expert.present?
			render json: expert, serializer: ExpertSerializer
		else
			render json: { error: 'Expert not found' }, status: :not_found
		end
	end

	def create 	
		expert = Expert.new(params[:data].as_json.except("profile_picture"))
		expert.profile_picture.attach(params[:data][:profile_picture])
		if expert.save
			render json: {exper: ExpertSerializer.new(expert)}
		else
			render json: { error: 'Failed to create expert' }, status: :unprocessable_entity
		end
	end

	
	def update 	
		expert = Expert.find_by(id: params[:id])
		expert.update(params[:data].as_json.except("profile_picture"))
		expert.profile_picture.attach(params[:data][:profile_picture])
		if expert.save
			render json: {exper: ExpertSerializer.new(expert)}
		else
			render json: { error: 'expert not found ' }, status: :unprocessable_entity
		end
	end


	def expert_courses
		expert = Expert.find_by(id: params[:expert_id])
		if expert.present?
			courses = expert.courses
			render json: courses
		else
			render json: { error: 'Expert not found' }, status: :not_found
		end
	end

	def destroy
		expert = Expert.find_by(id: params[:id])
		if expert.present?
			expert.destroy
			render json: { message: 'Expert deleted successfully'}
		else
			render json: { error: 'Expert not found' }, status: :not_found
		end
	end

	private

	def expert_params
		params.require(:expert).permit(:name, :description, :expertise, :profile_picture)
	end
end
