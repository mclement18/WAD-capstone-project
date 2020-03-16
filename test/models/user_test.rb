require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "create a user" do
    user = User.new email: 'user@email.com', password: 'password'
    assert user.save
  end

  test "email is requiered" do
    user = User.new email: '', password: 'password'
    refute user.valid?
  end

  test "password is requiered" do
    user = User.new email: 'user@email.com'
    refute user.valid?
  end

  test "password is encrypted" do
    User.create! email: 'user@email.com', password: 'password'
    user = User.last
    refute user.password.present?
    assert user.password_digest.present?
    refute_equal user.password_digest, 'password'
  end

  test "email must be valid" do
    user_1 = User.new email: 'user@email', password: 'password'
    refute user_1.valid?
    user_2 = User.new email: 'useremail.com', password: 'password'
    refute user_2.valid?
    user_3 = User.new email: 'user @email com', password: 'password'
    refute user_3.valid?
  end

  test "email is downcased before validation" do
    user = User.create! email: 'UsEr@eMaIl.com', password: 'password'
    assert_equal user.email, 'user@email.com'
  end

  test " email must be unique" do
    User.create! email: 'user@email.com', password: 'password'
    user = User.new email: 'UsEr@eMaIl.com', password: 'password'
    refute user.valid?
  end

  test "user default role is registered" do
    user = User.create! email: 'user@email.com', password: 'password'
    assert_equal user.role, 'registered'
  end

  test "user role is set to admin" do
    user = User.create! email: 'user@email.com', password: 'password', role: 'admin'
    assert_equal user.role, 'admin'
  end

  test " user role cannot be something else than registered or admin" do
    admin = User.new email: 'admin@email.com', password: 'password', role: 'admin'
    user = User.new email: 'user@email.com', password: 'password', role: 'registered'
    unvalid_role = User.new email: 'unvalid_role@email.com', password: 'password', role: 'something else'

    assert admin.valid?
    assert user.valid?
    refute unvalid_role.valid?
  end

  test "user deleted is false by default" do
    user = User.create! email: 'user@email.com', password: 'password'
    refute user.deleted
  end

  test "user is soft deleted" do
    user = User.create! email: 'user@email.com', password: 'password'
    assert user.soft_delete
    user = User.find(user.id)
    assert user.deleted
    assert_equal user.name, 'Deleted User'
    refute_equal user.email, 'user@email.com'
  end
end
