require 'test_helper'

class CemeteriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin_user       = users(:dags)
    @other_user       = users(:orange)
    @cemetery         = cemeteries(:test_cemetery)
  end

  test "should redirect index when not logged in" do
    get cemeteries_path
    assert_equal "Please log in.", flash[:danger]
    assert_redirected_to login_url
  end

  test "should redirect index when not admin user but logged in" do
    log_in_as(@other_user)
    get cemeteries_path
    assert_equal "Cemeteries accessible only to admins. Contact site owner for access.", flash[:danger]
    assert_redirected_to contact_url
  end

  test "should get cemeteries when admin user" do
    log_in_as(@admin_user)
    get cemeteries_path
    assert_response :success
  end

  test "should redirect show when not logged in" do
    get cemetery_path(@cemetery.id)
    assert_equal "Please log in.", flash[:danger]
    assert_redirected_to login_url
  end

  test "should redirect show when not admin user but logged in" do
    log_in_as(@other_user)
    get cemetery_path(@cemetery.id)
    assert_equal "Cemeteries accessible only to admins. Contact site owner for access.", flash[:danger]
    assert_redirected_to contact_url
  end

  test "should get cemetery when admin user" do
    log_in_as(@admin_user)
    get cemetery_path(@cemetery.id)
    assert_response :success
    assert_select "title", "#{@cemetery.name} | GIS toolkit"
  end

end
