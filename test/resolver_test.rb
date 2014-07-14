require 'test_helper'
require 'emcee/resolver.rb'

# Create a stub of Sprocket's Context class, so we can test if we're sending
# the correct messages to it.
class ContextStub
  attr_reader :assets

  def initialize
    @assets = []
  end

  def pathname
    "/"
  end

  def require_asset(asset)
    @assets << asset
  end

  def evaluate(path, options = {})
    "/* contents */"
  end
end

class ResolverTest < ActiveSupport::TestCase
  setup do
    @context = ContextStub.new
    @resolver = Emcee::Resolver.new(@context)
  end

  test "should have directory" do
    assert_equal @resolver.directory, "/"
  end

  test "should require assets" do
    assert_difference "@context.assets.length" do
      @resolver.require_asset("/asset1")
    end
  end

  test "should evaluate an asset" do
    assert_equal @resolver.evaluate("/test"), "/* contents */"
  end
end
