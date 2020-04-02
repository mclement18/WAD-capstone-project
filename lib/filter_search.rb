module FilterSearch
  class FilteredQuery
    include LocationSelectHelper
    
    attr_accessor :query, :stages_query,
                  :continent, :country, :region, :city, :location,
                  :category_1, :category_2, :categories
  
    def initialize(params = {})
      @query        = params.fetch(:query, '').strip
      @stages_query = params.fetch(:stages_query, '').strip
      @continent    = params.fetch(:continent, '')
      @country      = params.fetch(:country, '')
      @region       = params.fetch(:region, '')
      @city         = params.fetch(:city, '')
      @location     = params.fetch(:location, '')
      @category_1   = params.fetch(:category_1, '')
      @category_2   = params.fetch(:category_2, '')
      @categories   = params.fetch(:categories, '')
    end
  
    def unfiltered_trips_search
      serialize_query
      Trip.active.load_users.title_or_description(split_query_terms)
    end
    
    def search_trips
      serialize_for_search
      if @stages_query == ''
        Trip.active.load_users.filtered_search(split_query_terms, categories, location)
      else
        Trip.active.load_users.filtered_search(split_query_terms, categories, location).stages_search(split_stages_query_terms)
      end
    end

    def title
      title = []
      title << query
      title << stages_query
      title << I18n.t('categories.trip_and_category', category: I18n.t("categories.#{category_1}")) unless category_1 == ''
      title << I18n.t("categories.#{category_2}") unless category_2 == ''
      title << I18n.t("forms.continents.#{continent.downcase}") unless continent == ''
      title << get_country_name(country) unless country == ''
      title << get_region_name(country, region) unless region == ''
      title << city
      title.compact.split("").flatten.join(", ")
    end
    
    private

    def split_query_terms
      @serialized_query.split(' ')
    end

    def split_stages_query_terms
      @stages_query.split(' ')
    end

    def serialize_for_search
      serialize_query
      serialize_location
      serialize_categories
    end

    def serialize_query
      if @query == ''
        @serialized_query = '%'
      else
        @serialized_query = @query
      end
    end

    def serialize_location
      @location = [continent, country, region, city].compact.split("").flatten.join("__")
    end
  
    def serialize_categories
      @categories = [category_1, category_2].compact.split("").flatten.join("__")
    end
  end
end
