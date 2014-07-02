require 'test_helper'
require 'action_controller'

class DummyAppIntegrationTest < ActionController::TestCase
  tests DummyController

  test "the compiled assets should be served from the right directory" do
    get :index
    assert_match /href="\/assets\/application\.html"/, @response.body
  end

  # The dummy app has a custom route and controller action that renders the
  # compiled html import as a json response. We test against that here.
  test "the test files should get compiled and concatenated" do
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
      <polymer-element name="test6" attributes="source">
        <template>
          <img src="{{ source }}">
        </template>
      </polymer-element>
    EOS
  end
end
