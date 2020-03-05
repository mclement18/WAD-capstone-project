require 'test_helper'

class ToDoTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @trip = trips(:one)
  end
  
  test "create a to-do" do
    todo = ToDo.new user: @user, trip: @trip
    assert todo.save
  end

  test "must have a user" do
    todo = ToDo.new trip: @trip
    refute todo.valid?
  end

  test "must have a trip" do
    todo = ToDo.new user: @user
    refute todo.valid?
  end

  test "status is initialized to 'to-do'" do
    todo = ToDo.new user: @user, trip: @trip
    assert_equal todo.status, 'to-do'
  end

  test "status can be 'in-progress'" do
    todo = ToDo.new user: @user, trip: @trip, status: 'in-progress'
    assert todo.valid?
  end

  test "status can be 'done'" do
    todo = ToDo.new user: @user, trip: @trip, status: 'done'
    assert todo.valid?
  end

  test "status cannot be something else" do
    todo = ToDo.new user: @user, trip: @trip, status: 'anything else'
    refute todo.valid?
  end

  test "'traveling' transition change status from 'to-do' to 'in-progress'" do
    todo = ToDo.new user: @user, trip: @trip, status: 'to-do'
    assert todo.update_status('traveling')
    assert_equal todo.status, 'in-progress'
  end

  test "'arrived' transition change status from 'in-progress' to 'done'" do
    todo = ToDo.new user: @user, trip: @trip, status: 'in-progress'
    assert todo.update_status('arrived')
    assert_equal todo.status, 'done'
  end

  test "'cancel' transition change status from 'in-progress' to 'to-do'" do
    todo = ToDo.new user: @user, trip: @trip, status: 'in-progress'
    assert todo.update_status('cancel')
    assert_equal todo.status, 'to-do'
  end

  test "'cancel' transition change status from 'done' to 'to-do'" do
    todo = ToDo.new user: @user, trip: @trip, status: 'done'
    assert todo.update_status('cancel')
    assert_equal todo.status, 'to-do'
  end

  test "any unvalid transitions returns nil" do
    todo = ToDo.new user: @user, trip: @trip, status: 'to-do'
    refute todo.update_status('cancel')
    refute todo.update_status('arrived')

    todo.update_status('traveling')
    assert_equal todo.status, 'in-progress'
    refute todo.update_status('traveling')
    
    todo.update_status('arrived')
    assert_equal todo.status, 'done'
    refute todo.update_status('arrived')

    refute todo.update_status('any other value')
  end
end
