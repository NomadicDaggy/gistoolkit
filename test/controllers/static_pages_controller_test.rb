require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | GIS toolkit"
  end

	test "should get info" do
		get info_path
		assert_response :success
		assert_select "title", "Info | GIS toolkit"
	end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | GIS toolkit"
  end
end
