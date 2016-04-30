class Gram < ActiveRecord::Base
	validates :message, presence: true, length: { minimum: 2 }
	validates :picture, presence: true

	belongs_to :user

	mount_uploader :picture, PictureUploader
end
