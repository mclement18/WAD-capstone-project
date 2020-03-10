class LocationSelectController < ApplicationController
  def regions
    @query = :none if params[:country] == ''
    @query ||= params[:country]
    @regions = {'': 'None'}
    @regions.merge!(CS.states(@query))
    respond_to do |format|
      format.json { render json: @regions }
    end
  end

  def cities
    @cities_array = CS.cities(params[:region], params[:country])
    @cities_hash = {'': 'None'}
    if @cities_array
      @cities_array.each { |city| @cities_hash[city] = city }
    end

    respond_to do |format|
      format.json { render json: @cities_hash }
    end
  end
end
