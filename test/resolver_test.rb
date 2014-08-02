require 'test_helper'
require 'emcee/resolver.rb'

# Create a stub of Sprocket's Context class, so we can test if we're sending
# the correct messages to it.
class ContextStub
  attr_reader :asset_required, :evaluated

  def pathname
    "/"
  end

  def require_asset(asset)
    @asset_required = true
  end

  def evaluate(path, options = {})
    @evaluated = true
  end
end

class ResolverTest < ActiveSupport::TestCase
  setup do
    @context = ContextStub.new
    @resolver = Emcee::Resolver.new(@context)
  end

  test "should resolve absolute path" do
    assert_equal "/test.js", @resolver.absolute_path("test.js")
  end

  test "should require assets" do
    @resolver.require_asset("/asset1")
    assert @context.asset_required
  end

  test "should evaluate an asset" do
    @resolver.evaluate("/test")
    assert @context.evaluated
  end

  test "should indicate if asset should be inlined" do
    assert @resolver.should_inline?("test.css")
    assert @resolver.should_inline?("/vendor/assets/test.js")

    assert_not @resolver.should_inline?("//fonts.googleapis.com/css?family=RobotoDraft:regular,bold,italic,thin,light,bolditalic,black,medium&lang=en")
    assert_not @resolver.should_inline?("//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js")
  end
end
