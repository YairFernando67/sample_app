require 'rails_helper'

describe 'User Login', type: :request do
  describe 'POST #Login' do
    let(:user) { create(:random_user)}
    it 'login with invalid information' do
      get login_path
      expect(response.status).to eq(200)
      expect(response).to render_template('new')
      post login_path, params: { session: { email: '', password: '' } }
      expect(response).to render_template('new')
      expect(flash[:danger]).to be_present
      get root_path
      expect(flash[:danger]).not_to be_present
    end

    it 'login with valid information' do
      user = create(:user_login, email: 'yair.facio11@gmail.com', password: 'password')
      get login_path
      post login_path, params: { session: { email: user.email, password: 'password' } }
      assert is_logged_in?
      expect(response).to redirect_to action: :show, controller: :users, id: user.id
      assert_redirected_to user
      follow_redirect!
      assert_template 'users/show'
      assert_select 'a[href=?]', login_path, count: 0
      assert_select 'a[href=?]', logout_path
      assert_select 'a[href=?]', users_path
      assert_select 'a[href=?]', user_path(user)
      delete logout_path
      expect(is_logged_in?).to eq(false)
      assert_redirected_to root_path
      follow_redirect!
      assert_select 'a[href=?]', login_path
      assert_select 'a[href=?]', logout_path, count: 0
      assert_select 'a[href=?]', user_path(user), count: 0
      assert_select 'a[href=?]', user_path(user), count: 0
    end

    it 'login with valid information followed by logout' do
      user = create(:user_login, email: 'yair.facio11@gmail.com', password: 'password')
      get login_path
      post login_path, params: { session: { email: user.email, password: 'password' } }
      assert is_logged_in?
      assert_redirected_to user
      follow_redirect!
      assert_template 'users/show'
      assert_select "a[href=?]", login_path, count: 0
      assert_select "a[href=?]", logout_path
      assert_select "a[href=?]", user_path(user)
      delete logout_path
      expect(is_logged_in?).to eq(false)
      assert_redirected_to root_path

      delete logout_path
      follow_redirect!
      assert_select "a[href=?]", login_path
      assert_select "a[href=?]", logout_path, count: 0
      assert_select "a[href=?]", user_path(user), count: 0
    end

    it 'login with remembering' do
      user = create(:random_user)
      log_in_as(user, remember_me: '1')
      # assert_equal FILL_IN, assigns(:user).FILL_IN
      expect(cookies[:remember_token].empty?).to eq(false)
    end

    it 'login without remembering' do
      user = create(:random_user)
      log_in_as(user, remember_me: '1')
      log_in_as(user, remember_me: '0')
      expect(cookies[:remember_token].empty?).to eq(true)
    end
  end
end
