class CommentRelayJob < ApplicationJob
  queue_as :default

  def perform(comment, action)
    comment_to_render = render_comment(comment) unless action == 'delete'
    ActionCable.server.broadcast "#{comment.article_type.downcase}s:#{comment.article_id}:comments",
      comment: comment_to_render, comment_id: comment.id, user_id: comment.user_id, action: action
  end

  private

  def render_comment(comment)
    CommentsController.render(partial: 'comments/comment', locals: { comment: comment })
  end
end
