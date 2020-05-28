module StagesHelper
  def travel_type_options_array
    [
      ['None', 'None'],
      [t('forms.travel_types.driving'), 'driving'],
      [t('forms.travel_types.walking'), 'walking'],
      [t('forms.travel_types.bicycling'), 'bicycling'],
      [t('forms.travel_types.transit'), 'transit']
    ]
  end
  
  def travel_type_options(selected)
    options_for_select travel_type_options_array(), selected
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

  def stage_nav_link(trip, stage)
    if stage == 'None'
      return 'javascript:;'
    else
      return trip_stage_path(trip, stage)
    end
  end

  def stage_nav_class(stage)
    return 'btn--disabled' if stage == 'None'
  end

  def stage_travel_type(stage)
    if is_first_stage?(stage)
      'N/A'
    else
      t("forms.travel_types.#{stage.travel_type}")
    end
  end
end
