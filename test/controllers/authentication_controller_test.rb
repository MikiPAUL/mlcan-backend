require "test_helper"

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "should get signin" do
    get authentication_signin_url
    assert_response :success
  end

  test "should get resetpassword" do
    get authentication_resetpassword_url
    assert_response :success
  end

  test "should get signout" do
    get authentication_signout_url
    assert_response :success
  end
end
