require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "get new" do
    get new_user_url
    assert :success
  end

  test "get new via signup route" do
    get signup_url
    assert :success
  end

  test "create new user" do
    assert_difference('User.count') do
      post signup_url, params: { user: { email: 'new@wheretogo.com', password: 'password' } }
    end

    assert_redirected_to root_url
  end
end
