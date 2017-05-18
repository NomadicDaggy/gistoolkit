require 'test_helper'

class MapControllerTest < ActionDispatch::IntegrationTest
  test "should get map" do
    get root_path
    assert_response :success
    assert_select "title", "Map | GIS toolkit"
  end
end
