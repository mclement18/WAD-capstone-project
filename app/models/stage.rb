class Stage < ApplicationRecord
  belongs_to :trip
  has_many   :comments, -> { order(created_at: :desc) }, as: :article

  validates :title, presence: true, length: { maximum: 75 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :number, presence: true
  validates :travel_type, presence: true, inclusion: { in: %w(driving walking bicycling transit None) }
  validates :address, presence: true

  before_create :set_directions!
  before_update :update_directions!
  after_save :update_next_stage_directions!

  mount_uploader :image, ImageUploader

  def set_directions!(start_address = nil)
    if start_address
      self.directions = Gmaps.directions( start_address, address, mode: travel_type, alternatives: false)[0].to_json
    else
      if previous_stage == 'None'
        self.directions = 'None'
      else
        self.directions = Gmaps.directions( previous_stage.address, address, mode: travel_type, alternatives: false)[0].to_json
      end
    end
  end

  def next_stage
    if @next_stage.present?
      return @next_stage
    end
    @next_stage = Stage.order(updated_at: :desc) .find_by(trip_id: trip_id, number: number + 1)
    @next_stage ||= 'None'
  end
  
  def previous_stage
    if @previous_stage.present?
      return @previous_stage
    end
    @previous_stage = Stage.order(updated_at: :desc) .find_by(trip_id: trip_id, number: number - 1) unless number == 1
    @previous_stage ||= 'None'
  end

  private

  def update_directions!
    if will_save_change_to_number? || will_save_change_to_address? || will_save_change_to_travel_type?
      set_directions!
    end
  end

  def update_next_stage_directions!
    if next_stage != 'None' && saved_change_to_address?
      next_stage.set_directions!(self.address)
      next_stage.save
    end
  end
end
