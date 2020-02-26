require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  setup do
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
end
