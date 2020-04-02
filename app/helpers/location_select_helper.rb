module LocationSelectHelper
  def country_options(selected)
    options_for_select get_countries, selected
  end

  def region_options(country, selected)
    if selected.present?
      options_for_select get_regions(country), selected
    else
      options_for_select [[t('forms.choose_country'), '']]
    end
  end

  def city_options(country, region, selected)
    if selected.present?
      cities = get_cities(country, region)
      return options_for_select [['None', '']].concat(cities), selected if cities
      return options_for_select [['None', ''], selected], selected
    else
      options_for_select [[t('forms.choose_country'), '']]
    end
  end

  def get_countries
    options = [['None', '']]
    Carmen::Country.all.sort_alphabetical.each do |country|
      options.push [country.name, country.code]
    end
    return options
  end

  def get_regions(country)
    options = [['None', '']]
    CS.states(country).sort_alphabetical_by(&:last).each do |code, region|
      options.push [region, code.to_s]
    end
    return options
  end

  def get_cities(country, region)
    CS.cities(region, country).sort_alphabetical
  end

  def get_country_name(country_code)
    Carmen::Country.alpha_2_coded(country_code).name if country_code
  end

  def get_region_name(country_code, region_code)
    CS.states(country_code)[region_code.to_sym] if country_code && region_code
  end
end
