require 'carmen'

module TripsHelper
  include Carmen
  
  def category_1_options(selected)
    options_for_select [['None', ''], ['City trip', 'city'], ['Road trip', 'road'], ['International trip', 'international']], selected
  end

  def category_2_options(selected)
    options_for_select [['None', ''], ['Relaxing', 'relaxing'], ['Advanturous', 'advanturous'], ['Cultural', 'cultural']], selected
  end

  def continent_options(selected)
    options_for_select [['None', ''], ['America', 'America'], ['Africa', 'Africa'], ['Asia', 'Asia'], ['Europe', 'Europe'], ['Oceania', 'Oceania']], selected
  end

  def country_options(selected)
    options_for_select get_countries, selected
  end

  def region_options(country, selected)
    if selected.present?
      options_for_select get_regions(country), selected
    else
      options_for_select [['Choose a country', '']]
    end
  end

  def city_options(country, region, selected)
    if selected.present?
      cities = CS.cities(region, country)
      return options_for_select [['None', '']].concat(cities), selected if cities
      return options_for_select [['None', ''], selected], selected
    else
      options_for_select [['Choose a country', '']]
    end
  end

  def get_countries
    options = [['None', '']]
    Country.all.each do |country|
      options.push [country, country.code]
    end
    return options
  end

  def get_regions(country)
    options = [['None', '']]
    CS.states(country).each do |code, region|
      options.push [region, code]
    end
    return options
  end
end
