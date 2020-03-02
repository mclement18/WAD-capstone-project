class StagesController < ApplicationController
  before_action :ensure_authenticated
  before_action :load_trip
  before_action :set_stage, only: [:show, :edit, :update]
  
  def index
    @stages = @trip.stages
  end

  def new
    @stage = Stage.new
  end

  def create
    @stage = Stage.new stage_params
    @stage.number = @trip.stages.length + 1
    @stage.trip = @trip
    respond_to do |format|
      if @stage.save
        format.html { redirect_to trip_stage_path(@trip, @stage), notice: 'Stage successfully created!' }
      else
        format.html { render :new }
      end
    end
  end

  def show
  end

  def edit
  end

  private

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_stage
    @stage = Stage.find(params[:id])
  end

  def stage_params
    params.require(:stage).permit(:title, :description, :travel_type, :address, :image)
  end
end
