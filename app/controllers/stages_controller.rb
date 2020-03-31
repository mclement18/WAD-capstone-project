class StagesController < ApplicationController
  include RoleHelper
  
  before_action :ensure_authenticated
  before_action :load_trip
  before_action :set_stage, only: [:show, :edit, :update, :destroy]
  before_action :ensure_trip_stage_association, only: [:show, :edit, :update, :destroy]
  before_action :authorize_to_edit_stage, only: [:edit, :update, :destroy]
  before_action :authorize_to_reorder_stages, only: [:reorder]
  before_action :ensure_valid_stage_ids, only: :reorder
  
  def index
    @stages = @trip.stages
  end

  def reorder
    reorder_stages(reorder_params[:stages], @trip.id)

    respond_to do |format|
      format.html { redirect_to trip_path(@trip), notice: t('notices.stage_reordered') }
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

  def reorder_stages(stages, trip_id)
    update_next = false
    previous_address = nil

    1.upto(stages.keys.length) do |i|
      stage = Stage.find_by(id: stages["stage_#{i}".to_sym][:stage_id], trip_id: trip_id)

      stage.number = i

      if i == 1
        stage.travel_type = 'None'
      elsif stages["stage_#{i}".to_sym][:travel_type] == 'None'
        stage.travel_type = 'driving'
      else
        stage.travel_type = stages["stage_#{i}".to_sym][:travel_type]
        stage.travel_type = stage.travel_type_change_to_be_saved[1] unless stage.validate(:travel_type)
      end

      if stage.will_save_change_to_number?
        stage.set_directions!(previous_address)
        update_next = true
      else
        stage.set_directions!(previous_address) if !stage.will_save_change_to_travel_type? && update_next
        update_next = false
      end

      stage.update_next_stage_directions = false
      stage.save
      previous_address = stage.address
    end
  end

  def ensure_valid_stage_ids
    trip_stages_ids = []
    @trip.stages.each do |stage|
      trip_stages_ids.push(stage.id)
    end

    stages = reorder_params[:stages]
    
    begin
      unless stages.keys.length == trip_stages_ids.length
        raise StandardError.new t('errors.ids_not_match')
      end
  
      stages.each do |stage, values|
        id = values[:stage_id].to_i
        unless trip_stages_ids.include?(id)
          raise StandardError.new t('errors.ids_invalid')
        end
      end
    rescue StandardError => e
      respond_to do |format|
        format.html { redirect_to trip_stages_path(@trip), alert: "#{t('alerts.stage_reorder_fail')} #{e.message}" }
      end
    end
  end

  def stage_params
    params.require(:stage).permit(:title, :description, :travel_type, :address, :image)
  end

  def reorder_params
    params.require(:trip).permit(stages: {})
  end
end
