class Stage < ApplicationRecord
  belongs_to :trip

  validates :title, presence: true, length: { maximum: 75 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :number, presence: true
  validates :travel_type, presence: true, inclusion: { in: %w(driving walking bicycling transit None) }
  validates :address, presence: true

  before_create :set_directions!
  before_update :update_directions!
  after_save :update_next_stage_directions!

  def set_directions!(previous_stage=nil)
    if number == 1
      self.directions = "None"
    else
      previous_stage ||= trip.stages[number - 2]
      self.directions = Gmaps.directions( previous_stage.address, address, mode: travel_type, alternatives: false)[0].to_json
    end
  end

  private

  def update_directions!
    if will_save_change_to_number? || will_save_change_to_address? || will_save_change_to_travel_type?
      set_directions!
    end
  end

  def update_next_stage_directions!
    if next_stage != 'None' && saved_change_to_address?
      next_stage.set_directions!(self)
      next_stage.save
    end
  end

  def next_stage
    if @next_stage.present?
      return @next_stage
    end
    @next_stage = trip.stages[number]
    @next_stage ||= 'None'
  end
end
