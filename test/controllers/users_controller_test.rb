require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    app.default_url_options[:locale] = :en
  end
  
  test "get new" do
    get new_user_url
    assert_response :success
  end

  test "get new via signup route" do
    get signup_url
    assert_response :success
  end

  test "create new user" do
    assert_difference('User.count') do
      post signup_url, params: { user: { email: 'new@wheretogo.com', password: 'password' } }
    end

    assert_redirected_to root_url
    assert session[:user_id].present?
  end

  test "admin get users list" do
    sign_in_as('two@wheretogo.com')

    get users_url
    assert_response :success
  end

  test "admin get edit" do
    sign_in_as('two@wheretogo.com')

    get edit_user_url(users(:one))
    assert_response :success
  end

  test "admin update user" do
    sign_in_as('two@wheretogo.com')
    
    assert_changes('User.find(users(:one).id).name', from: 'One', to: 'New') do
      patch user_url(users(:one)), params: { user: { name: 'New' } }
    end
    assert_redirected_to edit_user_url(users(:one))
  end

  test "admin delete user" do
    sign_in_as('two@wheretogo.com')
    
    assert_changes('User.find(users(:one).id).deleted', from: false, to: true) do
      delete user_url(users(:one))
    end
    assert_redirected_to users_url
  end
end
