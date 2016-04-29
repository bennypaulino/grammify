require 'rails_helper'

RSpec.describe GramsController, type: :controller do
	describe "grams#destroy" do
		it "shouldn't allow a user to destroy a gram, if they didn't create it" do
			no_can_do = FactoryGirl.create(:gram)
			unlucky_troll = FactoryGirl.create(:user)
			sign_in unlucky_troll

			delete :destroy, id: no_can_do.id
			expect(response).to have_http_status(:forbidden)
		end


		it "should not let unauthenticated users destroy a gram" do
			lulz = FactoryGirl.create(:gram)
			delete :destroy, id: lulz.id
			expect(response).to redirect_to new_user_session_path
		end

		it "should allow a user to destroy grams" do
			garbage = FactoryGirl.create(:gram)
			sign_in garbage.user
			delete :destroy, id: garbage.id
			expect(response).to redirect_to root_path
			garbage = Gram.find_by_id(garbage.id)
			expect(garbage).to eq nil
		end

		it "should return a 404 message if we cannot find a gram with the id that is specified" do
			u = FactoryGirl.create(:user)
			sign_in u
			delete :destroy, id: 'QUESADILLACAT'
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "grams#update" do
		it "should not allow a user to update a gram if they didn't create it" do
			no_way = FactoryGirl.create(:gram)
			user = FactoryGirl.create(:user)
			sign_in user

			patch :update, id: no_way.id, gram: { message: 'yipeeee' }
			expect(response).to have_http_status(:forbidden)
		end

		it "should not let unauthenticated users update a gram" do
			denied = FactoryGirl.create(:gram)
			patch :update, id: denied.id, gram: { message: "Hello" }
			expect(response).to redirect_to new_user_session_path
		end


		it "should allow users to successfully update grams" do
			blah = FactoryGirl.create(:gram, message: "Initial Value")
			sign_in blah.user

			patch :update, id: blah.id, gram: { message: 'Changed' }
			expect(response).to redirect_to root_path
			blah.reload
			expect(blah.message).to eq "Changed"
		end

		it "should have http 404 error if the gram cannot be found" do
			u = FactoryGirl.create(:user)
			sign_in u

			patch :update, id: "ENCHILADACAT", gram: { message: 'Changed' }
			expect(response).to have_http_status(:not_found)
		end

		it "should render the edit form with an http status of unprocessable_entity" do
			lol = FactoryGirl.create(:gram, message: "Whutevah")
			sign_in lol.user

			patch :update, id: lol.id, gram: { message: '' }
			expect(response).to have_http_status(:unprocessable_entity)
			lol.reload
			expect(lol.message).to eq "Whutevah"
		end
	end

	describe "grams#edit" do
		it "shouldn't let a user who did not create the gram to edit the same gram" do
			nu_uh = FactoryGirl.create(:gram)
			user = FactoryGirl.create(:user)
			sign_in user
			get :edit, id: nu_uh.id
			expect(response).to have_http_status(:forbidden)
		end

		it "shouldn't allow unauthenticated users to edit a gram" do
			nope = FactoryGirl.create(:gram)
			get :edit, id: nope.id
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully show the edit form if the gram is found" do
			test_gram = FactoryGirl.create(:gram)
			sign_in test_gram.user

			get :edit, id: test_gram.id
			expect(response).to have_http_status(:success)
		end

		it "should return a 404 error message if the gram is not found" do
			boaty_mcboatface = FactoryGirl.create(:user)
			sign_in boaty_mcboatface

			get :edit, id: 'BURRITOCAT'
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "grams#show action" do
		it "should successfully show the page if the gram is found" do
			gram = FactoryGirl.create(:gram)
			get :show, id: gram.id
			expect(response).to have_http_status(:success)
		end

		it "shoud return a 404 error if the gram is not found" do
			get :show, id: 'TACOCAT'
			expect(response).to have_http_status(:not_found)
		end
	end


	describe "grams#index action" do
		it "should successfully show the page" do
			get :index
			expect(response).to have_http_status(:success)
		end
	end


	describe "grams#new action" do
		it "should require users to be logged in" do
			get :new
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully show the new form" do
			user = FactoryGirl.create(:user)
			sign_in user

			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#create action" do

		it "should require users to be logged in" do
			post :create, gram: { message: "Hello" }
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully create a new gram in the database" do
			user = FactoryGirl.create(:user)
			sign_in user

			post :create, gram: {message: 'Hello!'}
			expect(response).to redirect_to root_path

			gram = Gram.last
			expect(gram.message).to eq("Hello!")
			expect(gram.user).to eq(user)
		end

		it "should properly deal with validation errors" do
			user = FactoryGirl.create(:user)
			sign_in user

			post :create, gram: { message: '' }
			expect(response).to have_http_status(:unprocessable_entity)
			expect(Gram.count).to eq 0
		end
	end
end
