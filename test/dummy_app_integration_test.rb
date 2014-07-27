require 'test_helper'
require 'action_controller'
require 'coffee-rails'
require 'sass'

class DummyAppIntegrationTest < ActionController::TestCase
  tests DummyController

  # The dummy app has a custom route and controller action that renders the
  # compiled html import as a json response. We test against that here.
  test "the test files should get compiled and concatenated" do
    get :assets
    assert_equal @response.body, <<-EOS.strip_heredoc
    EOS
  end
end
