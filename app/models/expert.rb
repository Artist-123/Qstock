class Expert < ApplicationRecord
	has_many :courses, dependent: :destroy
end
