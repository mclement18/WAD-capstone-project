class CommentDeleteJob < ApplicationJob
  queue_as :default

  def perform(comment_id, article_id, article_type, user_id)
    ActionCable.server.broadcast "#{article_type.downcase}s:#{article_id}:comments",
      comment_id: comment_id, user_id: user_id, action: 'delete', message: I18n.t('comments.not_found')
  end
end
