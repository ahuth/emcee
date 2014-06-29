require 'test_helper'
require 'action_controller'

class DummyAppIntegrationTest < ActionController::TestCase
  tests DummyController

  test "should succesfully load the app and show index" do
    get :index
    assert_response :success
  end

  test "index should have html imports" do
    get :index
    assert_select "link[rel='import']"
  end

  test "the compiled assets should be served from the right directory" do
    get :index
    assert_match /href="\/assets\/application\.html"/, @response.body
  end

  # To test the contents of our compiled application.html, we have a custom route
  # and controller action. The controller action renders the compiled file as a
  # json response, which we can test against here.
  test "the test files should get concatenated" do
    get :assets
    assert_equal @response.body, <<-EOS.strip_heredoc
      <script>var life = "is good";
      </script>
      <p>test4</p>
      <style>p {
        color: red; }
      </style>
      <script>(function() {
        var hello;
        hello = "world";
      }).call(this);
      </script>
      <p>compiled scss and CoffeeScript</p>
      <style>p {
        color: pink;
      }
      </style>
      <p>test3</p>
      <p>test2</p>
      <p>test1</p>
    EOS
  end
end
