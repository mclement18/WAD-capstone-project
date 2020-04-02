require 'filter_search'

class CategoriesController < ApplicationController
  include CategoriesHelper
  include FilterSearch

  def index
    @category = params[:category]
    
    if params[:filtered_search] && params[:query]
      @display_search_title = true
      @filtered_query = FilteredQuery.new(params)
      @trips = @filtered_query.search_trips.categories_contains(@category).page(params[:page])
    else
      @display_search_title = false
      @filtered_query = FilteredQuery.new({find_category_class(@category) => @category})
      @trips = Trip.active.load_users.categories_contains(@category).page(params[:page])
    end
  end
end
