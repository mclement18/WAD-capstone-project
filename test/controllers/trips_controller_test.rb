require 'test_helper'

class TripsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trip = trips(:one)
  end
  
  test "get index" do
    get trips_url
    assert_response :success
    assert_select 'h3', @trip.title
  end

  test "get index with a simple search" do
    get trips_url, params: { q: 'Trip one' }
    assert_response :success
    assert_select 'h1', 'Results for "Trip one"'
  end

  test "get new" do
    sign_in_as('two@wheretogo.com')

    get new_trip_url
    assert_response :success
  end

  test "create new trip" do
    sign_in_as('two@wheretogo.com')
    
    assert_difference('Trip.count') do
      post trips_url, params: { trip: { title: 'New trip',
                                        description: "Trip's description",
                                        category_1: 'city',
                                        category_2: 'cultural',
                                        continent: 'Europe',
                                        country: 'CH',
                                        region: 'VD',
                                        city: 'Lausanne' } }
    end
    assert_redirected_to trip_url(Trip.last)
  end

  test "show trip" do
    get trip_url(@trip)
    assert_response :success
    assert_select 'h1', @trip.title
  end

  test "get edit" do
    sign_in_as('two@wheretogo.com')
    
    get edit_trip_url(@trip)
    assert_response :success
  end

  test "update a trip" do
    sign_in_as('two@wheretogo.com')

    patch trip_url(@trip), params: { trip: { title: 'New title',
                                             description: 'New description' } }
    assert_redirected_to trip_url(@trip)
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'New title'
    assert_select 'p.description', 'New description'
  end
end
