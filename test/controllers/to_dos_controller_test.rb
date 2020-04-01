require 'test_helper'

class ToDosControllerTest < ActionDispatch::IntegrationTest
  setup do
    app.default_url_options[:locale] = :en
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
    
    assert_changes('ToDo.find(@todo.id).status', from: 'to-do', to: 'in-progress') do
      patch user_to_do_url(@user, @todo), params: { transition: 'traveling' }, xhr: true
    end
    assert_response :success
  end

  test "delete a todo association" do
    assert_difference('ToDo.count', -1) do
      delete user_to_do_url(@user, to_dos(:one)), xhr: true
    end
    assert_response :success
  end

  test "unauthorized action" do
    assert_no_difference('ToDo.count') do
      delete user_to_do_url(@user, to_dos(:two)), xhr: true
    end
    assert_response :success
  end
end
