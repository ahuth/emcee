require 'test_helper'
require 'action_controller'

class ControllersTest < ActionController::TestCase
  tests DummyController

  test "should get index" do
    get :index
    assert_response :success
  end

  test "index should have html imports" do
    get :index
    assert_select "link[rel='import']"
  end
end
