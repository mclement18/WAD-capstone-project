class CommentsController < ApplicationController
  include RoleHelper
  
  before_action :ensure_authenticated
  before_action :load_article
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authorize_to_edit_comment, only: [:edit, :update, :destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.article = @article

    respond_to do |format|
      if @comment.save
        flash.now.notice = t('notices.comment_created')
        CommentRelayJob.perform_later(@comment, current_user.id, 'create')
      else
        flash.now.alert = t('alerts.comment_creation_fail')
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
        flash.now.notice = t('notices.comment_updated')
        CommentRelayJob.perform_later(@comment, current_user.id, 'update')
      else
        flash.now.alert = t('alerts.comment_update_fail')
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        flash.now.notice = t('notices.comment_destroyed')
        CommentDeleteJob.perform_later(@comment.id, @comment.article_id, @comment.article_type, current_user.id)
      else
        flash.now.alert = t('alerts.comment_deletion_fail')
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

  def authorize_to_edit_comment
    render 'application/not_allowed.js.erb' unless can_edit?(@comment)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
