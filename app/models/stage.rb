class Stage < ApplicationRecord
  attr_accessor :update_next_stage_directions
  
  belongs_to :trip
  has_many   :comments, -> { order(created_at: :desc) }, as: :article

  validates :title, presence: true, length: { maximum: 75 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :number, presence: true
  validates :travel_type, presence: true, inclusion: { in: %w(driving walking bicycling transit None) }
  validates :address, presence: true

  before_create :set_directions!
  before_update :update_directions!, unless: :will_save_change_to_directions?
  after_update_commit :update_next_stage_directions!, if: :update_next_stage_directions?

  mount_uploader :image, ImageUploader

  scope :recently_updated, -> { order(updated_at: :desc) }
  scope :find_next,        -> (trip_id, stage_number) { find_by(trip_id: trip_id, number: stage_number + 1) } 
  scope :find_previous,    -> (trip_id, stage_number) { find_by(trip_id: trip_id, number: stage_number - 1) } 

  def set_directions!(start_address = nil)
    if start_address
      self.directions = GmapsDirections.query( origin: start_address, destination: address, mode: travel_type, alternatives: false)[0].to_json
    else
      if previous_stage == 'None'
        self.directions = 'None'
      else
        self.directions = GmapsDirections.query( origin: previous_stage.address, destination: address, mode: travel_type, alternatives: false)[0].to_json
      end
    end
  end

  def next_stage
    if @next_stage.present?
      return @next_stage
    end
    @next_stage = Stage.recently_updated.find_next(trip_id, number)
    @next_stage ||= 'None'
  end
  
  def previous_stage
    if @previous_stage.present?
      return @previous_stage
    end
    @previous_stage = Stage.recently_updated.find_previous(trip_id, number) unless number == 1
    @previous_stage ||= 'None'
  end

  def update_next_stage_directions
    if @update_next_stage_directions.nil?
      true
    else
      @update_next_stage_directions
    end
  end

  def delete_from(current_trip = nil)
    current_trip ||= self.trip

    if self.destroy
      very_next_stage = true
      
      self.number.upto(current_trip.stages.count) do |i|
        stage = Stage.recently_updated.find_next(trip.id, i)
        stage.number = i
        stage.set_directions!(self.address) if very_next_stage
        stage.save
        very_next_stage = false
      end

      true      
    else
      false
    end
  end

  private

  def update_directions!
    if will_save_change_to_address? || will_save_change_to_travel_type?
      set_directions!
    end
  end

  def update_next_stage_directions?
    update_next_stage_directions
  end

  def update_next_stage_directions!
    if next_stage != 'None' && saved_change_to_address?
      next_stage.set_directions!(self.address)
      next_stage.save
    end
  end
end
