require 'test_helper'

class TripTest < ActiveSupport::TestCase
  test "create one trip" do
    trip = Trip.new title: "Trip's title",
                    description: "The trip's description",
                    category_1: 'city',
                    category_2: 'cultural',
                    continent: 'Europe',
                    country: 'CH',
                    region: 'VD',
                    city: 'Lausanne',
                    user: users(:one)
    assert trip.save
  end

  test "title is requiered" do
    trip = Trip.new description: "The trip's description",
                    category_1: 'city',
                    category_2: 'cultural',
                    continent: 'Europe',
                    country: 'CH',
                    region: 'VD',
                    city: 'Lausanne',
                    user: users(:one)
    refute trip.valid?
  end

  test "title is maximum 75 characters long" do
    trip = Trip.new title: "Trip's title Trip's title Trip's title Trip's title Trip's title Trip's title",
                    description: "The trip's description",
                    category_1: 'city',
                    category_2: 'cultural',
                    continent: 'Europe',
                    country: 'CH',
                    region: 'VD',
                    city: 'Lausanne',
                    user: users(:one)
    refute trip.valid?
  end

  test "description is requiered" do
    trip = Trip.new title: "Trip's title",
                    category_1: 'city',
                    category_2: 'cultural',
                    continent: 'Europe',
                    country: 'CH',
                    region: 'VD',
                    city: 'Lausanne',
                    user: users(:one)
    refute trip.valid?
  end

  test "description is maximum 500 characters long" do
    trip = Trip.new title: "Trip's title",
                    description: "The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description. The trip's description.",
                    category_1: 'city',
                    category_2: 'cultural',
                    continent: 'Europe',
                    country: 'CH',
                    region: 'VD',
                    city: 'Lausanne',
                    user: users(:one)
    refute trip.valid?
  end

  test "user is requiered" do
    trip = Trip.new title: "Trip's title",
                    description: "The trip's description",
                    category_1: 'city',
                    category_2: 'cultural',
                    continent: 'Europe',
                    country: 'CH',
                    region: 'VD',
                    city: 'Lausanne'
    refute trip.valid?
  end

  test "location attribute is computed on creation" do
    trip = Trip.create title: "Trip's title",
                       description: "The trip's description",
                       category_1: 'city',
                       category_2: 'cultural',
                       continent: 'Europe',
                       country: 'CH',
                       region: 'VD',
                       city: 'Lausanne',
                       user: users(:one)
    assert_equal trip.location, 'Europe__CH__VD__Lausanne'
  end

  test "location attribute is computed on update" do
    trip = Trip.create title: "Trip's title",
                       description: "The trip's description",
                       category_1: 'city',
                       category_2: 'cultural',
                       continent: 'Europe',
                       country: 'CH',
                       region: 'VD',
                       city: 'Lausanne',
                       user: users(:one)
    trip.update city: 'Morges'
    assert_equal trip.location, 'Europe__CH__VD__Morges'
  end

  test "location attribute is deserialized when retrieved from db" do
    Trip.create title: "Trip's title",
                description: "The trip's description",
                category_1: 'city',
                category_2: 'cultural',
                continent: 'Europe',
                country: 'CH',
                region: 'VD',
                city: 'Lausanne',
                user: users(:one)
    trip = Trip.last
    assert_equal trip.continent, 'Europe'
    assert_equal trip.country, 'CH'
    assert_equal trip.region, 'VD'
    assert_equal trip.city, 'Lausanne'
  end

  test "categories attribute is computed on creation" do
    trip = Trip.create title: "Trip's title",
                       description: "The trip's description",
                       category_1: 'city',
                       category_2: 'cultural',
                       continent: 'Europe',
                       country: 'CH',
                       region: 'VD',
                       city: 'Lausanne',
                       user: users(:one)
    assert_equal trip.categories, 'city__cultural'
  end

  test "categories attribute is computed on update" do
    trip = Trip.create title: "Trip's title",
                       description: "The trip's description",
                       category_1: 'city',
                       category_2: 'cultural',
                       continent: 'Europe',
                       country: 'CH',
                       region: 'VD',
                       city: 'Lausanne',
                       user: users(:one)
    trip.update category_2: 'relaxing'
    assert_equal trip.categories, 'city__relaxing'
  end

  test "categories attribute is deserialized when retrieved from db" do
    Trip.create title: "Trip's title",
                description: "The trip's description",
                category_1: 'city',
                category_2: 'cultural',
                continent: 'Europe',
                country: 'CH',
                region: 'VD',
                city: 'Lausanne',
                user: users(:one)
    trip = Trip.last
    assert_equal trip.category_1, 'city'
    assert_equal trip.category_2, 'cultural'
  end

  test "category_1 attribute can only be one of the following [city, road, international]" do
    city_trip = Trip.new title: "Trip's title",
                         description: "The trip's description",
                         category_1: 'city',
                         category_2: 'cultural',
                         continent: 'Europe',
                         country: 'CH',
                         region: 'VD',
                         city: 'Lausanne',
                         user: users(:one)
    assert city_trip.valid?
    road_trip = Trip.new title: "Trip's title",
                         description: "The trip's description",
                         category_1: 'road',
                         category_2: 'cultural',
                         continent: 'Europe',
                         country: 'CH',
                         region: 'VD',
                         city: 'Lausanne',
                         user: users(:one)
    assert road_trip.valid?
    international_trip = Trip.new title: "Trip's title",
                                  description: "The trip's description",
                                  category_1: 'international',
                                  category_2: 'cultural',
                                  continent: 'Europe',
                                  country: 'CH',
                                  region: 'VD',
                                  city: 'Lausanne',
                                  user: users(:one)
    assert international_trip.valid?
    other_trip = Trip.new title: "Trip's title",
                          description: "The trip's description",
                          category_1: 'other',
                          category_2: 'cultural',
                          continent: 'Europe',
                          country: 'CH',
                          region: 'VD',
                          city: 'Lausanne',
                          user: users(:one)
    refute other_trip.valid?
  end

  test "category_2 attribute can only be one of the following [relaxing, cultural, adventurous]" do
    relaxing_trip = Trip.new title: "Trip's title",
                             description: "The trip's description",
                             category_1: 'city',
                             category_2: 'relaxing',
                             continent: 'Europe',
                             country: 'CH',
                             region: 'VD',
                             city: 'Lausanne',
                             user: users(:one)
    assert relaxing_trip.valid?
    cultural_trip = Trip.new title: "Trip's title",
                             description: "The trip's description",
                             category_1: 'city',
                             category_2: 'cultural',
                             continent: 'Europe',
                             country: 'CH',
                             region: 'VD',
                             city: 'Lausanne',
                             user: users(:one)
    assert cultural_trip.valid?
    adventurous_trip = Trip.new title: "Trip's title",
                                description: "The trip's description",
                                category_1: 'city',
                                category_2: 'adventurous',
                                continent: 'Europe',
                                country: 'CH',
                                region: 'VD',
                                city: 'Lausanne',
                                user: users(:one)
    assert adventurous_trip.valid?
    other_trip = Trip.new title: "Trip's title",
                          description: "The trip's description",
                          category_1: 'city',
                          category_2: 'other',
                          continent: 'Europe',
                          country: 'CH',
                          region: 'VD',
                          city: 'Lausanne',
                          user: users(:one)
    refute other_trip.valid?
  end

  test "title_contains search records by titles one query" do
    terms = ['One']
    trips = Trip.title_contains(terms)
    assert_equal trips.length, 2
  end

  test "title_contains search records by titles two queries" do
    terms = ['One', 'second']
    trips = Trip.title_contains(terms)
    assert_equal trips.length, 3
  end

  test "description_contains search records by descriptions one query" do
    terms = ['One']
    trips = Trip.description_contains(terms)
    assert_equal trips.length, 1
  end

  test "description_contains search records by descriptions two queries" do
    terms = ['One', 'two']
    trips = Trip.description_contains(terms)
    assert_equal trips.length, 2
  end

  test "title_or_description search records by title or descriptions" do
    terms = ['One', 'two']
    trips = Trip.title_or_description(terms)
    assert_equal trips.length, 3
  end

  test "categories_contains search records by categories one category" do
    terms = 'city'
    trips = Trip.categories_contains(terms)
    assert_equal trips.length, 1
  end

  test "categories_contains search records by categories two categories" do
    terms = 'international__relaxing'
    trips = Trip.categories_contains(terms)
    assert_equal trips.length, 1
  end

  test "location_contains search records by location continent" do
    terms = 'Europe'
    trips = Trip.location_contains(terms)
    assert_equal trips.length, 3
  end

  test "location_contains search records by location region" do
    terms = 'BE'
    trips = Trip.location_contains(terms)
    assert_equal trips.length, 2
  end

  test "filtered_search search by title and description with categories filters" do
    terms = ['one']
    categories = 'city'
    location = ''
    trips = Trip.filtered_search(terms, categories, location)
    assert_equal trips.length, 1
  end

  test "filtered_search search by title and description with location filters" do
    terms = ['one']
    categories = ''
    location = 'VD'
    trips = Trip.filtered_search(terms, categories, location)
    assert_equal trips.length, 1
  end

  test "filtered_search search by title and description with categories and location filters" do
    terms = ['one', 'description']
    categories = 'adventurous'
    location = 'CH'
    trips = Trip.filtered_search(terms, categories, location)
    assert_equal trips.length, 1
  end

  test "trip deleted is false by default" do
    trip = Trip.create! title: "Trip's title",
                        description: "The trip's description",
                        category_1: 'city',
                        category_2: 'cultural',
                        continent: 'Europe',
                        country: 'CH',
                        region: 'VD',
                        city: 'Lausanne',
                        user: users(:one)
    refute trip.deleted
  end

  test "trip is soft deleted if present in a user's to do list" do
    trip = trips(:two)
    assert trip.to_dos.any?
    assert trip.soft_delete_if_needed
    trip = Trip.find(trip.id)
    assert trip.deleted
    assert_equal users(:two).trips.count, 1
  end

  test "trip is destroyed if not present in any to do list" do
    trip = trips(:one)
    refute trip.to_dos.any?
    assert_difference('Trip.count', -1) do
      assert trip.soft_delete_if_needed
    end
    assert trip.destroyed?
  end
end
