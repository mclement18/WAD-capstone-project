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
end
