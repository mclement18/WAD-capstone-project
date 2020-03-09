module CommentsHelper
  def comment_path(comment)
    return trip_comment_path(comment.article, comment) if comment.article.class == Trip
    return stage_comment_path(comment.article, comment) if comment.article.class == Stage
  end

  def edit_comment_path(comment)
    return edit_trip_comment_path(comment.article, comment) if comment.article.class == Trip
    return edit_stage_comment_path(comment.article, comment) if comment.article.class == Stage
  end
end
