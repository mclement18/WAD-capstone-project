module Account
  class ToDosController < ApplicationController
    before_action :ensure_authenticated
    
    def dreams
      @todos = current_user.dreams
      @title = 'Your To Do List'
      render :index
    end

    def travels
      @todos = current_user.travels
      @title = 'Your current Trips'
      render :index
    end

    def success
      @todos = current_user.success
      @title = 'Your completed Trips'
      render :index
    end
  end
end
