require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    user = users(:one)
    trip = trips(:one)
  end
  
  test "create a comment for a trip" do
    comment = Comment.new body: 'A new comment',
                          user: user,
                          article: trip
    assert comment.save
  end

  test "create a comment for a stage" do
    comment = Comment.new body: 'A new comment',
                          user: user,
                          article: stages(:one)
    assert comment.save
  end

  test "body is required" do
    comment = Comment.new user: user,
                          article: trip
    refute comment.valid?
  end

  test "body cannot be more than 300 characters" do
    comment = Comment.new body: 'A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment A new comment',
                          user: user,
                          article: trip
    refute comment.valid?
  end

  test "user is required" do
    comment = Comment.new body: 'A new comment',
                          article: trip
    refute comment.valid?
  end

  test "article is required" do
    comment = Comment.new body: 'A new comment',
                          user: user
    refute comment.valid?
  end
end
