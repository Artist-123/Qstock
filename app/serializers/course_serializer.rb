class CourseSerializer < ActiveModel::Serializer
	attributes :id, :title, :category, :price, :expert_id
end