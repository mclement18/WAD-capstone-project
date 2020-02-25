class TripsController < ApplicationController
  def index
    if params[:q].present?
      @queries = params[:q].strip.split(' ')
      @trips = Trip.global_search(@queries)
    else
      @trips = Trip.all
    end
  end
end
