class Gram < ActiveRecord::Base
	validates :message, presence: true, length: { minimum: 2 }

	belongs_to :user
end
