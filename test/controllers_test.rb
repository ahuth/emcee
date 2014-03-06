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

  # To test the contents of our compiled application.html, we have a custom route
  # and controller action. The controller action renders the compiled file as a
  # json response, which we can test against here.
  test "the test files should get compiled and concatenated" do
    get :assets
    assert_response :success
    assert_equal @response.body, <<-EOS
<script>var life = "is good";
</script>
<p>test4</p>
<style>
p {
  color: pink;
}
</style>
<p>test3</p>
<p>test2</p>
<p>test1</p>
EOS
  end
end
