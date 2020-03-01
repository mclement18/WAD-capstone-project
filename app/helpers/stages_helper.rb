module StagesHelper
  def travel_type_options(selected)
    options_for_select [['None', 'None'], ['Driving', 'driving'], ['Walking', 'walking'], ['Bicycling', 'bicycling'], ['Transit', 'transit']], selected
  end

  def is_first_stage?(stage)
    stage.number == 1
  end
end
