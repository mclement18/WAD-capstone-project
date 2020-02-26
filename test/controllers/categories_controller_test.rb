require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "get advanturous trips" do
    get categories_url('advanturous')
    assert_response :success
    assert_select 'h3', 'A second journey'
  end

  test "get city trips" do
    get categories_url('city')
    assert_response :success
    assert_select 'h3', 'Trip one'
  end

  test "get cultural trips with successful search" do
    get categories_url('cultural'), params: { q: 'Bern' }
    assert_response :success
    assert_select 'h3', 'Trip one'
  end

  test "get cultural trips with unsuccessful search" do
    get categories_url('cultural'), params: { q: 'GR' }
    assert_response :success
    assert_select '.not-found'
  end
end
