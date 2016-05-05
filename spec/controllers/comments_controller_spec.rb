require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	describe "comments#destroy action" do	
		it "shouldn't allow a user to destroy a comment, if they didn't create the comment" do		
 			c = FactoryGirl.create(:comment)
 			unlucky_troll = FactoryGirl.create(:user)		
 			sign_in unlucky_troll

			delete :destroy, { id: c.id }
			expect(response).to have_http_status(:forbidden)
 		end

		it "should return a 404 message if a comment can't be found with the id that is specified" do					
			c = FactoryGirl.create(:comment)
			sign_in c.user

			delete :destroy, { id: 'FLAUTACAT' } 
			expect(response).to have_http_status(:not_found)
 		end

		it "should not let unauthenticated users destroy a comment" do		
 			g = FactoryGirl.create(:gram)
 			no_power = FactoryGirl.create(:comment)
			delete :destroy, { gram_id: g.id, id: no_power.id }
			expect(response).to redirect_to new_user_session_path
 		end	

 		it "should allow a user to destroy a comment" do		
 			foot_in_mouth = FactoryGirl.create(:comment)		
 			sign_in foot_in_mouth.user	

 			expect do 
 				delete :destroy, { id: foot_in_mouth.id }
 			end.to change{ Comment.count }.by(-1)
 			expect(response).to redirect_to root_path
 			
 		end			
 				
 	end


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
			expect(response).to have_http_status(:not_found)
		end


	end

end
