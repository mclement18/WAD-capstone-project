class ToDosController < ApplicationController
  before_action :ensure_authenticated
  before_action :set_todo, only: [:update, :destroy]
  
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
    
  end

  def destroy
    
  end

  private

  def set_todo
    @todo = ToDo.find(params[:id])
  end
end
