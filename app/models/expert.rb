class Expert < ApplicationRecord
	has_many :courses, dependent: :destroy
	 has_one_attached :profile_picture
end
