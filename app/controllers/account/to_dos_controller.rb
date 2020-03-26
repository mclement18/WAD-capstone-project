module Account
  class ToDosController < ApplicationController
    before_action :ensure_authenticated
    
    def dreams
      @todos = current_user.dreams.load_users.page(params[:page])
      @title = 'Your To Do List'
      @current_page = 'todolist'
      render :index
    end

    def travels
      @todos = current_user.travels.load_users.page(params[:page])
      @title = 'Your current Trips'
      @current_page = 'travels'
      render :index
    end

    def success
      @todos = current_user.success.load_users.page(params[:page])
      @title = 'Your completed Trips'
      @current_page = 'success'
      render :index
    end
  end
end
