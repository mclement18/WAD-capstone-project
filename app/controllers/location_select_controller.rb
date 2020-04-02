class LocationSelectController < ApplicationController
  include LocationSelectHelper
  
  def regions
    if params[:country] == ''
      @query = :none # delibaretly set a unvalid query to retrieve nill
    else
      @query = params[:country]
    end
    
    @regions = get_regions(@query)
    
    respond_to do |format|
      format.json { render json: @regions }
    end
  end

  def cities
    @cities = [['None', '']]
    get_cities(params[:country], params[:region]).each { |city| @cities << [city, city] }

    respond_to do |format|
      format.json { render json: @cities }
    end
  end
end
