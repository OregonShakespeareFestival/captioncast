require 'test_helper'

class CastControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
