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
          <p hidden?="{{ hidden }}">hidden</p>
          <img src="{{ source }}">
        </template>
      </polymer-element>
      <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
      <p>External script</p>
    EOS
  end
end
