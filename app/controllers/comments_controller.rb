class CommentsController < ApplicationController
  before_action :ensure_authenticated
  before_action :load_article
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.article = @article

    respond_to do |format|
      if @comment.save
        flash.now.notice = 'Comment successfully created!'
      else
        flash.now.alert = 'Unable to save comment'
      end
      format.js
    end
  end

  def show
  end

  def edit
  end
  
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        flash.now.notice = 'Comment successfully updated!'
      else
        flash.now.alert = 'Unable to update comment'
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        flash.now.notice = 'Comment successfully deleted!'
      else
        flash.now.alert = 'Unable to delete comment.'
      end
      format.js
    end
  end

  private

  def load_article
    @article = Trip.find(params[:trip_id]) if params[:trip_id].present?
    @article = Stage.find(params[:stage_id]) if params[:stage_id].present?
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
