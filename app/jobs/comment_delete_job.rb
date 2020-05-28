class CommentDeleteJob < ApplicationJob
  queue_as :default

  def perform(comment_id, article_id, article_type, action_owner)
    ActionCable.server.broadcast "#{article_type.downcase}s:#{article_id}:comments",
      comment_id: comment_id, user_id: action_owner, action: 'delete'
  end
end
