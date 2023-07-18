require "test_helper"

class Api::V1::AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "should get signin" do
    get api_v1_authentication_signin_url
    assert_response :success
  end

  test "should get resetpassword" do
    get api_v1_authentication_resetpassword_url
    assert_response :success
  end

  test "should get signout" do
    get api_v1_authentication_signout_url
    assert_response :success
  end
end
