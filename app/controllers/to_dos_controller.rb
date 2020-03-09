class ToDosController < ApplicationController
  include RoleHelper
  
  before_action :ensure_authenticated
  before_action :set_todo, only: [:update, :destroy]
  before_action :authorize_to_edit_todo, only: [:update, :destroy]
  
  def create
    @todo = ToDo.new user: current_user, trip_id: params[:trip_id]
    respond_to do |format|
      if @todo.save
        flash.now.notice = 'Trip successfully added to your To Do List!'
      else
        flash.now.alert = 'Unable to add Trip to your To Do List.'
      end
      format.js
    end
  end

  def update
    respond_to do |format|
      if @todo.update_status(params[:transition])
        @todo.save
        case @todo.status
        when 'in-progress' then flash.now.notice = 'Trip added to your current Trips!'
        when 'done'        then flash.now.notice = 'Trip added to your completed Trips!'
        when 'cancel'      then flash.now.notice = 'Trip moved back to your To Do List.'
        end
      else
        flash.now.alert = 'Unable to update to do status. Wrong transition...'
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @todo.destroy
        flash.now.notice = 'Trip successfully removed from your list!'
      else
        flash.now.alert = 'Unable to remove trip from your list.'
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
