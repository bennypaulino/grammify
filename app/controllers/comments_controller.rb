class CommentsController < ApplicationController
	before_action :authenticate_user!
	def create
		@gram = Gram.find_by_id(params[:gram_id])
		return render_not_found if @gram.blank?
		@gram.comments.create(comment_params.merge(user: current_user))
		redirect_to root_path
	end

	def destroy
		@comment = Comment.find_by_id(params[:id])
		return render_not_found if @comment.blank?
		return render_not_found(:forbidden) if @comment.user != current_user # && @gram.user != current_user
		@comment.destroy
	  redirect_to root_path
	end


	# current_user.comments.where(id: params[:id], gram_id: params[:gram_id]).first
	# this will ensure that the user can access that comment...

	# for your tests be careful about the gram belonging to the user vs the comment belonging to the user

	private

	def comment_params
		params.require(:comment).permit(:message)
	end
end
