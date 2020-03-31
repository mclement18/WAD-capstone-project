class ToDosController < ApplicationController
  include RoleHelper
  
  before_action :ensure_authenticated
  before_action :set_todo, only: [:update, :destroy]
  before_action :authorize_to_edit_todo, only: [:update, :destroy]
  
  def create
    @todo = ToDo.new user: current_user, trip_id: params[:trip_id]
    respond_to do |format|
      if @todo.save
        flash.now.notice = t('notices.todo_created')
      else
        flash.now.alert = t('alerts.todo_creation_fail')
      end
      format.js
    end
  end

  def update
    respond_to do |format|
      if @todo.update_status(params[:transition]) && @todo.save
        case params[:transition]
        when 'traveling' then flash.now.notice = t('notices.todo_started')
        when 'arrived'   then flash.now.notice = t('notices.todo_finished')
        when 'cancel'    then flash.now.notice = t('notices.todo_reset')
        end
      else
        flash.now.alert = t('alerts.todo_update_fail')
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @todo.destroy
        flash.now.notice = t('notices.todo_deleted')
      else
        flash.now.alert = t('alerts.todo_deletion_fail')
      end
      format.js
    end
  end

  private

  def set_todo
    @todo = ToDo.find(params[:id])
  end

  def authorize_to_edit_todo
    render 'application/not_allowed.js.erb' unless can_edit?(@todo)
  end
end
