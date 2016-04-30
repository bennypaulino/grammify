class Gram < ActiveRecord::Base
	validates :message, presence: true, length: { minimum: 2 }
	validates :picture, presence: true

	belongs_to :user
	has_many :comments

	mount_uploader :picture, PictureUploader
end
