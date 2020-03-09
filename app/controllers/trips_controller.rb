class TripsController < ApplicationController
  include RoleHelper
  
  before_action :ensure_authenticated,   only: [:new, :create, :edit, :update]
  before_action :set_trip,               only: [:show, :edit, :update, :destroy]
  before_action :authorize_to_edit_trip, only: [:edit, :update, :destroy]
  
  def index
    if params[:q].present?
      @queries = params[:q].strip.split(' ')
      @trips = Trip.global_search(@queries)
    else
      @trips = Trip.all
    end
  end

  def show
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new trip_params
    @trip.user = current_user
    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip successfully created!' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: 'Trip successfully updated!' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @trip.soft_delete_if_needed
        format.html { redirect_to account_trips_path, notice: 'Trip successfully deleted!' }
      else
        format.html { redirect_to trip_path(@trip), alert: 'Unable to delete trip.' }
      end
    end
  end
  
  private

  def trip_params
    params.require(:trip).permit(:title, :description, :category_1, :category_2, :continent, :country, :region, :city, :image)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def authorize_to_edit_trip
    redirect_to trip_path(@trip) unless can_edit?(@trip)
  end
end
