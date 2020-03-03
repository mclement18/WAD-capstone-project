class CommentsController < ApplicationController
  before_action :ensure_authenticated
  before_action :set_article

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.article = @article

    respond_to do |format|
      if @comment.save
        @comment_was_saved = true
        flash.now.notice = 'Comment successfully created!'
      else
        @comment_was_saved = false
        flash.now.alert = 'Unable to save comment'
      end
      format.js
    end
  end

  private

  def set_article
    @article = Trip.find(params[:trip_id]) if params[:trip_id].present?
    @article = Stage.find(params[:stage_id]) if params[:stage_id].present?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
