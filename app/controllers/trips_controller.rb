require 'filter_search'

class TripsController < ApplicationController
  include RoleHelper
  include FilterSearch
  
  before_action :ensure_authenticated,   only: [:new, :create, :edit, :update]
  before_action :set_trip,               only: [:show, :edit, :update, :destroy]
  before_action :authorize_to_edit_trip, only: [:edit, :update, :destroy]
  
  def index
    if params[:filtered_search] && params[:query]
      @display_search_title = true
      @filtered_query = FilteredQuery.new(params)
      @trips = @filtered_query.search_trips.page(params[:page])
    elsif params[:q].present?
      @display_search_title = true
      @filtered_query = FilteredQuery.new({ query: params[:q] })
      @trips = @filtered_query.unfiltered_trips_search.page(params[:page])
    else
      @display_search_title = false
      @filtered_query = FilteredQuery.new
      @trips = Trip.active.load_users.page(params[:page])
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
        format.html { redirect_to @trip, notice: t('notices.trip_created') }
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
        format.html { redirect_to @trip, notice: t('notices.trip_updated') }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @trip.soft_delete_if_needed
        format.html { redirect_to account_trips_path, notice: t('notices.trip_destroyed') }
        flash.now.notice = t('notices.trip_destroyed')
        format.js
      else
        format.html { redirect_to trip_path(@trip), alert: t('alerts.trip_deletion_fail') }
        flash.now.alert = t('alerts.trip_deletion_fail')
        format.js
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
    redirect_to trip_path(@trip), alert: t('alerts.not_allowed') unless can_edit?(@trip)
  end
end
