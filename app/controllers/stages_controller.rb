class StagesController < ApplicationController
  before_action :ensure_authenticated
  before_action :load_trip
  before_action :ensure_valid_stage_ids, only: :reorder
  before_action :set_stage, only: [:show, :edit, :update]
  
  def index
    @stages = @trip.stages
  end

  def reorder
    reorder_stages(reorder_params[:stages], @trip.id)

    respond_to do |format|
      format.html { redirect_to trip_path(@trip), notice: 'Stages successfully reordered!' }
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

  def update
    respond_to do |format|
      if @stage.update stage_params
        format.html { redirect_to trip_stage_path(@trip, @stage), notice: 'Stage successfully updated' }
      else
        format.html { render :edit }
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

  def reorder_stages(stages, trip_id)
    update_next = false

    1.upto(stages.keys.length) do |i|
      stage = Stage.find_by(id: stages["stage_#{i}".to_sym][:stage_id], trip_id: trip_id)

      stage.number = i

      stage.travel_type = stages["stage_#{i}".to_sym][:travel_type]
      stage.travel_type = stage.travel_type_change_to_be_saved[1] unless stage.validate(:travel_type)

      if stage.will_save_change_to_number?
        update_next = true
      else
        stage.set_directions! if !stage.will_save_change_to_travel_type? && update_next
        update_next = false
      end

      stage.save
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
        raise StandardError.new "The number of stage ids and actual trip stages number don't match."
      end
  
      stages.each do |stage, values|
        id = values[:stage_id].to_i
        unless trip_stages_ids.include?(id)
          raise StandardError.new 'Non valid stage ids were sent.'
        end
      end
    rescue StandardError => e
      respond_to do |format|
        format.html { redirect_to trip_stages_path(@trip), alert: "Unable to reorder stages. #{e.message}" }
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