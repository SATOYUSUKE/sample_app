require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end

  # test "should get signup" do
  #   get signup_url
  #   assert_response :success
  # end

end
