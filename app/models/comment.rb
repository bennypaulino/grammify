class Comment < ActiveRecord::Base
	belongs_to :gram
	belongs_to :user
	validates :message, presence: true, length: { minimum: 2 }
end
