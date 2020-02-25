require 'carmen'

module TripsHelper
  include Carmen
  
  def category_1_options
    options_for_select [['None', ''], ['City trip', 'city'], ['Road trip', 'road'], ['International trip', 'international']], ''
  end

  def category_2_options
    options_for_select [['None', ''], ['Relaxing', 'relaxing'], ['Advanturous', 'advanturous'], ['Cultural', 'cultural']], ''
  end

  def continent_options
    options_for_select [['None', ''], ['America', 'America'], ['Africa', 'Africa'], ['Asia', 'Asia'], ['Europe', 'Europe'], ['Oceania', 'Oceania']], ''
  end

  def country_options
    options_for_select get_countries, ''
  end

  def get_countries
    options = [['None', '']]
    Country.all.each do |country|
      options.push [country, country.code]
    end
    return options
  end
end
