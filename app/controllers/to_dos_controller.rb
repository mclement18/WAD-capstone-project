class ToDosController < ApplicationController
  before_action :ensure_authenticated
  before_action :set_todo
  
  def create
    
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
