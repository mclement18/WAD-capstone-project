class TripsController < ApplicationController
  def index
    if params[:q].present?
      @queries = params[:q].strip.split(' ')
      @trips = Trip.global_search(@queries)
    else
      @trips = Trip.all
    end
  end

  def show
    @trip = Trip.find(params[:id])
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new trip_params
    @trip.user = User.first
    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip successfully created' }
      else
        format.html { render :new }
      end
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:title, :description, :category_1, :category_2, :continent, :country, :region, :city, :image)
  end
end
