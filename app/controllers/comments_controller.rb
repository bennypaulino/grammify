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
		return render_not_found(:forbidden) unless [@comment.user, @comment.gram.user].include? current_user
		@comment.destroy
	  redirect_to root_path
	end

	# line 14 replaced the following:	
	# return render_not_found(:forbidden) if @comment.user != current_user && @comment.gram.user != current_user

	private

	def comment_params
		params.require(:comment).permit(:message)
	end
end