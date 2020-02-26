require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "get new" do
    get login_url
    assert_response :success
  end

  test "create new session" do
    post login_url, params: { email: 'one@wheretogo.com', password: 'testpassword' }
    assert_redirected_to root_url
    assert session[:user_id].present?
  end

  test "delete session" do
    post login_url, params: { email: 'one@wheretogo.com', password: 'testpassword' }
    delete logout_url
    assert_redirected_to root_url
    refute session[:user_id].present?
  end
end
