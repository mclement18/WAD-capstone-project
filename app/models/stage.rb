class Stage < ApplicationRecord
  belongs_to :trip

  validates :title, presence: true, length: { maximum: 75 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :number, presence: true
  validates :travel_type, presence: true, inclusion: { in: %w(driving walking bicycling transit) }
  validates :address, presence: true

  before_update :update_directions!

  private

  def set_directions!
    if number == 1
      self.directions = "None"
    else
      previous_stage = trip.stages[number - 2]
      self.directions = gmaps.directions( previous_stage, address, mode: travel_mode, alternatives: false)[0].to_json
    end
  end

  def update_directions!
    changed_attributes = self.changed
    if changed_attributes.include?('number') || changed_attributes.include?('address') || changed_attributes.include?('travel_type')
      set_directions!
    end
  end
end
