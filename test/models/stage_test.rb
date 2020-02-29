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

  test "travel_type can be either driving, walking, bicycling, transit or None" do
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
    none_stage = Stage.new title: 'New stage',
                              description: "Stage's description",
                              number: 1,
                              travel_type: 'None',
                              address: 'there',
                              trip: trips(:two)
    assert none_stage.valid?
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

  test "directions is set upon creatation" do
    stage = Stage.new title: 'New stage',
                      description: "Stage's description",
                      number: 1,
                      travel_type: 'driving',
                      address: 'there',
                      trip: trips(:two)
    assert stage.directions.nil?
    stage.save!
    stage = Stage.find(stage.id)
    refute stage.directions.nil?
  end

  test "directions is set to None if first stage" do
    stage = Stage.create title: 'New stage',
                         description: "Stage's description",
                         number: 1,
                         travel_type: 'driving',
                         address: 'there',
                         trip: trips(:two)
    stage = Stage.find(stage.id)
    assert_equal stage.directions, 'None'
  end

  test "directions is calculated using previuos stage address" do
    stage = Stage.create title: 'New stage',
                         description: "Stage's description",
                         number: 4,
                         travel_type: 'driving',
                         address: 'Vevey',
                         trip: trips(:one)
    refute stage.directions.nil?
    stage = Stage.find(stage.id)
    assert JSON.parse(stage.directions)['legs'][0]['start_address'].include? stages(:three).address
  end

  test "directions is updated if number attribute is changed" do
    stage = stages(:two)
    refute_equal stage.directions, 'None'
    stage.update! number: 1
    stage = Stage.find(stage.id)
    assert_equal stage.directions, 'None'
  end

  test "directions is updated if travel_type attribute is changed" do
    stage = stages(:two)
    previous_directions = stage.directions
    stage.update! travel_type: 'bicycling'
    stage = Stage.find(stage.id)
    refute_equal stage.directions, previous_directions
  end

  test "directions and next stage (if any) directions are updated if address attribute is changed" do
    stage_2 = stages(:two)
    stage_3 = stages(:three)
    stage_2_previous_directions = stage_2.directions
    stage_3_previous_directions = stage_3.directions
    stage_2.update! address: 'Genève'
    stage_2 = Stage.find(stage_2.id)
    stage_3 = Stage.find(stage_3.id)
    refute_equal stage_2.directions, stage_2_previous_directions
    refute_equal stage_3.directions, stage_3_previous_directions
  end
end
