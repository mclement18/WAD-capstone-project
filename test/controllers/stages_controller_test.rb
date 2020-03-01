require 'test_helper'

class StagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as('one@wheretogo.com')
    @trip = trips(:one)
    @stage = stages(:one)
  end

  test "get index" do
    get trip_stages_url(@trip)
    assert_response :success
  end

  test "reorder trip stages" do
    @stage_2 = stages(:two)
    @stage_3 = stages(:three)

    assert_changes('@trip.stages.first.title', from: 'First stage', to: 'Second stage') do
      patch reorder_trip_stages_url(@trip), params: { trip: { 
                                                        stages: { 
                                                          stage_1: { 
                                                            stage_id: @stage_2.id,
                                                            travel_type: @stage.travel_type
                                                          },
                                                          stage_2: { 
                                                            stage_id: @stage.id,
                                                            travel_type: @stage_2.travel_type
                                                          },
                                                          stage_3: { 
                                                            stage_id: @stage_3.id,
                                                            travel_type: @stage_3.travel_type
                                                          } 
                                                        } 
                                                      }
                                                    }
    end
    assert_redirected_to trip_url(@trip)
  end
  
  test "get new" do
    get new_trip_stage_url(@trip)
    assert_response :success
  end

  test "create a stage" do
    assert_different('Stage.count') do
      post trip_stages_url(@trip), params: { stage: { title: 'New title',
                                                 description: 'New description',
                                                 number: 1,
                                                 travel_type: 'driving',
                                                 address: 'there' } }
    end
    assert_redirected_to trip_stage_url(@trip, Stage.last)
  end
  
  test "get show" do
    get trip_stage_url(@trip, @stage)
    assert_response :success
    assert_select 'h1', @stage.title
  end

  test "get edit" do
    get edit_trip_stage_url(@trip, @stage)
    assert_response :success
  end

  test "update stage" do
    patch trip_stage_url(@trip, @stage), params: { stage: { title: 'New title', descritpion: 'New description' } }
    assert_redirected_to trip_stage_url(@trip, @stage)
    follow_redirect!
    assert_select 'h1', 'New title'
    assert_select '.description', 'New description'
  end
end
