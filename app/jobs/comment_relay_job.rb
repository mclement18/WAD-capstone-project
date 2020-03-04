class CommentRelayJob < ApplicationJob
  queue_as :default

  def perform(comment)
    ActionCable.server.broadcast "#{comment.article_type.downcase}s:#{comment.article_id}:comments",
      comment: render_comment(comment), user_id: comment.user_id
  end

  private

  def render_comment(comment)
    CommentsController.render(partial: 'comments/comment', locals: { comment: comment })
  end
end
