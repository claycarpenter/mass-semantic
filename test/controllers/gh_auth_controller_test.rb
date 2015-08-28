require 'test_helper'

class GhAuthControllerTest < ActionController::TestCase
  test "should get callback" do
    get :callback
    assert_response :success
  end

  test "should get sign_in" do
    get :sign_in
    assert_response :success
  end

end
