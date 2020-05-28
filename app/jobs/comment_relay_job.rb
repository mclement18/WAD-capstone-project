class CommentRelayJob < ApplicationJob
  include ActionView::Helpers::DateHelper
  include CommentsHelper
  
  queue_as :default

  def perform(comment, action_owner, action)
    ActionCable.server.broadcast "#{comment.article_type.downcase}s:#{comment.article_id}:comments",
      comment: parse_comment(comment), user_id: action_owner, action: action
  end

  private

  def parse_comment(comment)
    {
      id: "comment_id_#{comment.id}",
      body: comment.body,
      isForm: false,
      user: {
        id: comment.user.id,
        name: comment.user.name,
        avatar_url: comment.user.avatar_url,
        path: user_path(comment.user)
      },
      date: {
        formated: comment.created_at.strftime("%FT%T"),
        timeToParse: comment.created_at.strftime("%b %d, %Y %H:%M:%S GMT")
      },
      edit: {
        path: edit_comment_path(comment)
      },
      delete: {
        path: comment_path(comment)
      }
    }
  end
end
