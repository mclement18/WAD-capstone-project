class CommentRelayJob < ApplicationJob
  include ActionView::Helpers::DateHelper
  include CommentsHelper
  
  queue_as :default

  def perform(comment, action)
    ActionCable.server.broadcast "#{comment.article_type.downcase}s:#{comment.article_id}:comments",
      comment: parse_comment(comment), user_id: comment.user_id, action: action
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
        text: I18n.t('comments.date', time: time_ago_in_words(comment.created_at))
      },
      edit: {
        text: I18n.t('links.edit'),
        path: edit_comment_path(comment)
      },
      delete: {
        text: I18n.t('links.delete'),
        path: comment_path(comment),
        confirm: I18n.t('notices.are_you_sure')
      }
    }
  end
end
