class ExpertSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :description, :expertise
  attribute :profile_picture do |object|

  def profile_picture
    rails_blob_path(object.profile_picture, only_path: true) if object.profile_picture.attached?
  end
end
end
