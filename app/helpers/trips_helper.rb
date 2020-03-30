module TripsHelper
  def category_1_options(selected)
    options_for_select [['None', ''], ['City trip', 'city'], ['Road trip', 'road'], ['International trip', 'international']], selected
  end

  def category_2_options(selected)
    options_for_select [['None', ''], ['Relaxing', 'relaxing'], ['Adventurous', 'adventurous'], ['Cultural', 'cultural']], selected
  end

  def continent_options(selected)
    options_for_select [['None', ''], ['America', 'America'], ['Africa', 'Africa'], ['Asia', 'Asia'], ['Europe', 'Europe'], ['Oceania', 'Oceania']], selected
  end

  def trip_form_cancel_path(trip)
    if trip.created_at
      return trip_path(trip)
    else
      return account_trips_path
    end
  end

  def display_attribute(attribute)
    if attribute
      attribute
    else
      'N/A'
    end
  end

  def merge_stages_directions(trip)
    directions_array = []
    trip.stages.each do |stage|
      directions_array << JSON.parse(stage.directions) unless is_first_stage?(stage)
    end
    directions_array.to_json
  end
end
