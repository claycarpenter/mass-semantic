require 'test_helper'

class SeAuthControllerTest < ActionController::TestCase
  test "should get callback" do
    get :callback
    assert_response :success
  end

end
