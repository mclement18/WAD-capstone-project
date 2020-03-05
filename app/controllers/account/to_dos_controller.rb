module Account
  class ToDosController < ApplicationController
    before_action :ensure_authenticated
    
    def dreams
      @todos = current_user.dreams
    end

    def travels
      @todos = current_user.travels
    end

    def success
      @todos = current_user.success
    end
  end
end
