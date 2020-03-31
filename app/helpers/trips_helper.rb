module TripsHelper
  def category_1_options(selected)
    options_for_select [
                         ['None', ''],
                         [t('categories.trip_and_category', category: t('categories.city')), 'city'],
                         [t('categories.trip_and_category', category: t('categories.road')), 'road'],
                         [t('categories.trip_and_category', category: t('categories.international')), 'international']
                       ],
                       selected
  end

  def category_2_options(selected)
    options_for_select [
                         ['None', ''],
                         [t('categories.relaxing'), 'relaxing'],
                         [t('categories.adventurous'), 'adventurous'],
                         [t('categories.cultural'), 'cultural']
                       ],
                       selected
  end

  def continent_options(selected)
    options_for_select [
                         ['None', ''],
                         [t('forms.continents.america'), 'America'],
                         [t('forms.continents.africa'), 'Africa'],
                         [t('forms.continents.asia'), 'Asia'],
                         [t('forms.continents.europe'), 'Europe'],
                         [t('forms.continents.oceania'), 'Oceania']
                       ],
                       selected
  end

  def trip_form_cancel_path(trip)
    if trip.created_at
      return trip_path(trip)
    else
      return account_trips_path
    end
  end

  def display_attribute(attribute, continent=false)
    if attribute
      if continent
        t("forms.continents.#{attribute.downcase}")
      else
        attribute
      end
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
