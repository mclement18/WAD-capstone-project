require 'test_helper'

class ToDosControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as('one@wheretogo.com')
    @user = users(:one)
  end
  
  test "create a todo association" do
    assert_difference('ToDo.count') do
      post user_to_dos_url(@user), params: { trip_id: trips(:one).id }, xhr: true
    end
    assert_response :success
  end

  test "update a todo association" do
    @todo = to_dos(:one)
    
    assert_changes('@todo.status', from: 'to-do', to: 'in-progress') do
      patch user_to_do_url(@user, @todo), params: { transition: 'traveling' }, xhr: true
    end
    assert_response
  end

  test "delete a todo association" do
    assert_difference('ToDo.count', -1) do
      delete user_to_do_url(@user, to_dos(:one)), xhr: true
    end
    assert_response :success
  end
end
