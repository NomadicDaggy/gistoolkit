require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get map" do
    get root_path
    assert_response :success
    assert_select "title", "Map | GIS toolkit"
  end

  test "should get home" do
    get home_path
    assert_response :success
    assert_select "title", "Home | GIS toolkit"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | GIS toolkit"
  end

	test "should get about" do
		get about_path
		assert_response :success
		assert_select "title", "About | GIS toolkit"
	end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | GIS toolkit"
  end

end
