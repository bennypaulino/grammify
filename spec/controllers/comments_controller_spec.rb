require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	describe "comments#create action" do
		it "should allow users to create comments on grams" do
			sample_gram = FactoryGirl.create(:gram)

			u = FactoryGirl.create(:user)
			sign_in u

			post :create, gram_id: sample_gram.id, comment: { message: 'awesome gram' }
			expect(response).to redirect_to root_path
			expect(sample_gram.comments.length).to eq 1
			expect(sample_gram.comments.first.message).to eq 'awesome gram'
		end

		it "should require a user to be logged in before they may comment on a gram" do
			g = FactoryGirl.create(:gram)
			post :create, gram_id: g.id, comment: { message: "I'm not logged in" }
			expect(response).to redirect_to new_user_session_path	
		end

		it "should return http status code 404 Not Found if the gram isn't found (invalid id)" do
			u = FactoryGirl.create(:user)
			sign_in u
			post :create, gram_id: 'WALDO', comment: { message: 'where are you?' }
			expect(response).to have_http_status :not_found
		end


	end

end
