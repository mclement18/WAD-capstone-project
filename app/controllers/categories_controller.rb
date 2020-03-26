class CategoriesController < ApplicationController
  def index
    @category = params[:category]
    return @trips = Trip.active.load_users.categories_contains([@category]).page(params[:page]) unless params[:q].present?
    
    @queries = params[:q].strip.split(' ')
    @trips = Trip.active.load_users.categories_contains([@category]).global_search(@queries).page(params[:page])
  end
end
