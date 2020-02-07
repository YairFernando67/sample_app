require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    { name: 'Pablo',
      email: 'pablo12@gmail.com',
      password: 'password',
      password_confirmation: 'password' }
  end
  let(:user) { FactoryBot.create(:user) }
  let(:users) { create_list(:random_user, 5) }
  before(:all) do
    # @user = FactoryBot.create(:user)
  end

  describe 'GET #Index' do
    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template('index')
    end
  end

  describe 'Get #New' do
    it 'has a 200 status code' do
      get :new
      expect(response.status).to eq(200)
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    it 'is valid with valid attributes' do
      User.create! valid_attributes
      get :index, params: {}
      expect(response.content_type).to eq 'text/html'
      expect(response).to be_successful
    end

    it 'is not valid with a invalid name' do
      user.name = nil
      expect(user).not_to be_valid
    end

    it 'is not valid with a invalid email' do
      user.email = 'ss'
      expect(user).not_to be_valid
    end

    it 'is not valid with a invalid password' do
      user.password = 'pass'
      user.password_confirmation = 'pass'
      expect(user).not_to be_valid
    end

    it 'is not valid with different password and password confirmation' do
      user.password = 'passwword'
      user.password_confirmation = 'passwordd'
      expect(user).not_to be_valid
    end
  end

  describe 'POST #Find user id when creating post' do
    let(:post) { FactoryBot.create(:post, user_id: user.id) }
    let(:my_user) { User.find post.user_id }

    it 'sets the user_id field' do
      expect(post.user_id).to eq(my_user.id)
    end
  end

  describe 'POST #Create list of users' do
    it 'return a list of users' do
      expect(users.size).to eq(5)
    end
  end

  describe 'GET #Show a user' do
    it 'returns with a 200 status code' do
      get :show, params: { id: user.id }
      expect(response.status).to eq(200)
      expect(response).to render_template :show
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PUT #Edit a user' do
    it 'updates a user' do
      new_attributes = { name: 'Joaquin Mata', email: 'joaquin@gmail.com',
                         password: 'password12345', password_confirmation: 'password12345' }
      user = create(:random_user)
      put :update, params: { id: user.id, user: new_attributes }
      user.reload
      expect(assigns(:user).attributes['name']).to match(new_attributes[:name])
      expect(assigns[:user]).not_to be_new_record
    end
  end

  describe 'DELETE #Destroy a user and its posts' do
    it 'delete a user' do
      user = create(:random_user)
      delete :destroy, params: { id: user.id }
      expect(user.posts.count).to eq(0)
      expect(flash[:notice]).to be_present
    end
  end
end
