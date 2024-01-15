class ExpertSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :expertise, :profile_picture
  
  def profile_picture
  if object.profile_picture.attached?
  		Rails.application.routes.url_helpers.rails_blob_path(object.profile_picture, only_path: true)	
  	end
  end
end
