module Account
  class ToDosController < ApplicationController
    before_action :ensure_authenticated
    
    def dreams
      @todos = current_user.dreams
      @title = 'Your To Do List'
      @current = 'todo'
      render :index
    end

    def travels
      @todos = current_user.travels
      @title = 'Your current Trips'
      @current = 'travels'
      render :index
    end

    def success
      @todos = current_user.success
      @title = 'Your completed Trips'
      @current = 'done'
      render :index
    end
  end
end
