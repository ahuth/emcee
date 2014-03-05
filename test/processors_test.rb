require 'test_helper'

# Testing a class that inherits from Sprockets::DirectiveProcessor is difficult,
# so we've split out the methods we want to test into a module, and we'll include
# them here in a stub class.
class ProcessorStub
  include Emcee::Processors::Includes

  private
  def read_file(path)
    "/* contents */"
  end
end

# Create a stub of Sprocket's Context class, so we can test if we're 'requiring'
# assets correctly.
class ContextStub
  attr_reader :assets

  def initialize
    @assets = []
  end

  def require_asset(asset)
    @assets << asset
  end
end

class ProcessorsTest < ActiveSupport::TestCase
  setup do
    @processor = ProcessorStub.new
    @context = ContextStub.new
    @directory = "/dir"
    @body = %Q{
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    }
  end

  test "processing imports should work" do
    processed = @processor.process_imports(@body, @context, @directory)
    assert_equal 1, @context.assets.length
    assert_equal "/dir/test.html", @context.assets[0]

    assert_equal processed, %q{
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    }
  end

  test "processing stylesheets should work" do
    processed = @processor.process_stylesheets(@body, @directory)
    assert_equal processed, %q{
      <link rel="import" href="test.html">
      <style>/* contents */</style>
      <script src="test.js"></script>
      <p>test</p>
    }
  end

  test "processing scripts should work" do
    processed = @processor.process_scripts(@body, @directory)
    assert_equal processed, %q{
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script>/* contents */</script>
      <p>test</p>
    }
  end
end
