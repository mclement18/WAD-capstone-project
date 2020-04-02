require 'trip_stages_reordering'

class StagesController < ApplicationController
  include RoleHelper
  include TripStagesReordering
  
  before_action :ensure_authenticated
  before_action :load_trip
  before_action :set_stage, only: [:show, :edit, :update, :destroy]
  before_action :ensure_trip_stage_association, only: [:show, :edit, :update, :destroy]
  before_action :authorize_to_edit_stage, only: [:edit, :update, :destroy]
  before_action :authorize_to_reorder_stages, only: [:reorder]
  before_action :ensure_valid_input_for_reorder, only: :reorder
  
  def index
    @stages = @trip.stages
  end

  def reorder
    respond_to do |format|
      if reorder_stages(@trip, reorder_params[:stages])
        format.html { redirect_to trip_path(@trip), notice: t('notices.stages_reordered') }
      else
        format.html { redirect_to trip_path(@trip), notice: t('alerts.stages_reorder_fail') }
      end
    end
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
        format.html { redirect_to trip_stage_path(@trip, @stage), notice: t('notices.stage_created') }
      else
        format.html { render :new }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @stage.update stage_params
        format.html { redirect_to trip_stage_path(@trip, @stage), notice: t('notices.stage_updated') }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @stage.delete_from(@trip)
        format.html { redirect_to trip_path(@trip), notice: t('notices.stage_destroyed') }
      else
        format.html { redirect_to trip_stage_path(@trip, @stage), alert: t('alerts.stage_deletion_fail') }
      end
    end
  end

  private

  def load_trip
    @trip = Trip.find(params[:trip_id])
  end

  def set_stage
    @stage = Stage.find(params[:id])
  end

  def ensure_trip_stage_association
    redirect_to trip_path(@trip), alert: t('alerts.not_allowed') unless @stage.trip_id == @trip.id
  end

  def authorize_to_edit_stage
    redirect_to trip_stage_path(@trip, @stage), alert: t('alerts.not_allowed') unless can_edit?(@trip)
  end

  def authorize_to_reorder_stages
    redirect_to trip_path(@trip), alert: t('alerts.not_allowed') unless can_edit?(@trip)
  end

  def ensure_valid_input_for_reorder
    errors = validates_all(@trip, reorder_params[:stages])
    redirect_to trip_stages_path(@trip), alert: errors.to_s if errors.messages.any?
  end

  def stage_params
    params.require(:stage).permit(:title, :description, :travel_type, :address, :image)
  end

  def reorder_params
    params.require(:trip).permit(stages: {})
  end
end
