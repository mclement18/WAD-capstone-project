class CommentDeleteJob < ApplicationJob
  queue_as :default

  def perform(comment_id, article_id, article_type)
    ActionCable.server.broadcast "#{article_type.downcase}s:#{article_id}:comments",
      comment_id: comment_id, action: 'delete'
  end
end
