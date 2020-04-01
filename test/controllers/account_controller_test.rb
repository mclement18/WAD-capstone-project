require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  setup do
    app.default_url_options[:locale] = :en
    sign_in_as('two@wheretogo.com')
  end
  
  test "get show" do
    get account_url
    assert_response :success
  end

  test "get edit" do
    get edit_account_url
    assert_response :success
  end

  test "update current user account details" do
    patch account_url, params: { user: { name: 'New name' } }
    assert_redirected_to account_url
    follow_redirect!
    assert_select '.name', 'New name'
  end

  test "get account/trips#index" do
    get account_trips_url
    assert_response :success
  end

  test "get account/to_dos#dreams" do
    get account_todolist_url
    assert_response :success
  end

  test "get account/to_dos#travels" do
    get account_travels_url
    assert_response :success
  end

  test "get account/to_dos#success" do
    get account_success_url
    assert_response :success
  end

  test "delete account" do
    assert_changes('User.find(users(:two).id).deleted', from: false, to: true) do
      delete account_url
    end
    assert_redirected_to root_url
    refute session[:user_id].present?
  end
end
