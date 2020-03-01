class StagesController < ApplicationController
  before_action :ensure_authenticated
  before_action :load_trip
  
  def index
    @stages = @trip.stages
  end

  def new
    @stage = Stage.new
  end

  private

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end
end
