require 'carmen'

module LocationSelectHelper
  include Carmen

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
