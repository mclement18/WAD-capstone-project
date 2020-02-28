require 'test_helper'

class StageTest < ActiveSupport::TestCase
  test "create a stage" do
    stage = Stage.new title: 'New stage',
                      description: "Stage's description",
                      number: 1,
                      travel_type: 'driving',
                      address: 'there',
                      trip: trips(:two)
    assert stage.save
  end

  test "title is requiered" do
    stage = Stage.new description: "Stage's description",
                      number: 1,
                      travel_type: 'driving',
                      address: 'there',
                      trip: trips(:two)
    refute stage.valid?
  end

  test "tilte cannot be more than 75 characters long" do
    stage = Stage.new title: 'New stage New stage New stage New stage New stage New stage New stage New stage',
                      description: "Stage's description",
                      number: 1,
                      travel_type: 'driving',
                      address: 'there',
                      trip: trips(:two)
    refute stage.valid?
  end

  test "description id requiered" do
    stage = Stage.new title: 'New stage',
                      number: 1,
                      travel_type: 'driving',
                      address: 'there',
                      trip: trips(:two)
    refute stage.valid?
  end

  test "description cannot be more than 500 characters long" do
    stage = Stage.new title: 'New stage',
                      description: "Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description Stage's description",
                      number: 1,
                      travel_type: 'driving',
                      address: 'there',
                      trip: trips(:two)
    refute stage.valid?
  end

  test "number is requiered" do
    stage = Stage.new title: 'New stage',
                      description: "Stage's description",
                      travel_type: 'driving',
                      address: 'there',
                      trip: trips(:two)
    refute stage.valid?
  end

  test "travel_type is requiered" do
    stage = Stage.new title: 'New stage',
                      description: "Stage's description",
                      number: 1,
                      address: 'there',
                      trip: trips(:two)
    refute stage.valid?
  end

  test "travel_type can be either driving, walking, bicycling or transit" do
    driving_stage = Stage.new title: 'New stage',
                              description: "Stage's description",
                              number: 1,
                              travel_type: 'driving',
                              address: 'there',
                              trip: trips(:two)
    assert driving_stage.valid?
    walking_stage = Stage.new title: 'New stage',
                              description: "Stage's description",
                              number: 1,
                              travel_type: 'walking',
                              address: 'there',
                              trip: trips(:two)
    assert walking_stage.valid?
    bicycling_stage = Stage.new title: 'New stage',
                                description: "Stage's description",
                                number: 1,
                                travel_type: 'bicycling',
                                address: 'there',
                                trip: trips(:two)
    assert bicycling_stage.valid?
    transit_stage = Stage.new title: 'New stage',
                              description: "Stage's description",
                              number: 1,
                              travel_type: 'transit',
                              address: 'there',
                              trip: trips(:two)
    assert transit_stage.valid?
  end

  test "travel_type cannot be something else" do
    stage = Stage.new title: 'New stage',
                      description: "Stage's description",
                      number: 1,
                      travel_type: 'anything else',
                      address: 'there',
                      trip: trips(:two)
    refute stage.valid?
  end

  test "address is requiered" do
    stage = Stage.new title: 'New stage',
                      description: "Stage's description",
                      number: 1,
                      travel_type: 'driving',
                      trip: trips(:two)
    refute stage.valid?
  end

  test "trip is requiered" do
    stage = Stage.new title: 'New stage',
                      description: "Stage's description",
                      number: 1,
                      travel_type: 'driving',
                      address: 'there'
    refute stage.valid?
  end
end
