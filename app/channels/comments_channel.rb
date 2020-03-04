class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "#{data['article_type'].downcase}s:#{data['article_id']}:comments"
  end

  def unfollow
    stop_all_streams
  end
end
