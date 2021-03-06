module Account
  class TripsController < ApplicationController
    before_action :ensure_authenticated
    
    def index
      @trips = current_user.trips.load_users.page(params[:page])
    end
  end
end