require 'test_helper'

class SemanticControllerTest < ActionController::TestCase
  test "should get benefits" do
    get :benefits
    assert_response :success
  end

end
