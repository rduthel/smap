require 'test_helper'

class AdditionalDriversControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get additional_drivers_new_url
    assert_response :success
  end

  test "should get edit" do
    get additional_drivers_edit_url
    assert_response :success
  end

  test "should get update" do
    get additional_drivers_update_url
    assert_response :success
  end

  test "should get create" do
    get additional_drivers_create_url
    assert_response :success
  end

end
