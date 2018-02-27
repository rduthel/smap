require 'test_helper'

class DriverProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get profile" do
    get driver_profiles_profile_url
    assert_response :success
  end

end
