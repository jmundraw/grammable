require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "gram#destroy action" do 
    it "should allow a user to destroy grams" do 
      # gram = FactoryGirl.create(:gram)
      gram = Gram.create(message: "hello")
      delete :destroy, id: gram.id 
      expect(response).to redirect_to root_path
      gram = Gram.find_by_id(gram.id)
      expect(gram).to eq nil    
    end

    it "should return 404 if gram not found" do 
      delete :destroy, id: 'fake'
      expect(response).to have_http_status(:not_found)
      

    end
  end

  describe "grams#udpate action" do 
    it "should successfully update gram in database" do
      gram = Gram.create(message: "Original")
      # gram = FactoryGirl.create(:gram, message: "Original")
      patch :update, id: gram.id, gram: { message: "New message"}
      expect(response).to redirect_to root_path
      gram.reload
      expect(gram.message).to eq "New message"

    end

    it "should return 404 if gram not found" do
      patch :update, id: 'Hi', gram: { message: 'Chaned'}
      expect(response).to have_http_status(:not_found)

    end

    it "should render the edit form with status unprocessable_entity if blank" do 
      # gram = FactoryGirl.create(:gram, message: "Original")
      gram = Gram.create(message: "Original")
      patch :update, id: gram.id, gram: { message: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq "Original"

    end
  end

  describe "grams#edit action" do 
    it "should successfully show the edit page if it is found" do
      # gram = FactoryGirl.create(:gram)
      gram = Gram.create(message: "hello")
      get :edit, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 message if the gram is not found" do 
      get :edit, id: 'what'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#show action" do 
    it "should successfully show the page if gram is found" do
      # gram = FactoryGirl.create(:gram)
      gram = Gram.create(message: "hello")
      get :show, id: gram.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do 
      get :show, id: 'Hello'
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
      # user = FactoryGirl.create(:user)
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )      
      sign_in user
  		get :new
  		expect(response).to have_http_status(:success)
  	end
  end

  describe "grams#create action" do 
    it "should require users to be logged in" do
      post :create, gram: { message: "Hello"}
      expect(response).to redirect_to new_user_session_path

    end

    it "should not allow blank messages to be saved" do
      user = User.create(
        email:                 'fakeuser@gmail.com',
        password:              'secretPassword',
        password_confirmation: 'secretPassword'
      )
      # FactoryGirl.create(:user)
      sign_in user
      post :create, gram: {message: ""}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Gram.count).to eq 0
    end

    it "should successfully create a new gram in our database" do
      # user = FactoryGirl.create(:user)
        user = User.create(
          email:                 'fakeuser@gmail.com',
          password:              'secretPassword',
          password_confirmation: 'secretPassword'
        )
      sign_in user 
      post :create, gram: {message: "Hello!"}
      expect(response).to redirect_to root_path
      
      gram = Gram.last
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end
  end
end
