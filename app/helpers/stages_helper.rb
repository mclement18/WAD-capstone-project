module StagesHelper
  def travel_type_options(selected)
    options_for_select [['None', 'None'], ['Driving', 'driving'], ['Walking', 'walking'], ['Bicycling', 'bicycling'], ['Transit', 'transit']], selected
  end

  def is_first_stage?(stage)
    stage.number == 1
  end

  def map_query(address)
    if address
      address
    else
      'Machu Picchu, 08680, Peru'
    end
  end

  def stage_form_cancel_path(trip, stage)
    if stage.created_at
      return trip_stage_path(trip, stage)
    else
      return trip_path(trip)
    end
  end
end
