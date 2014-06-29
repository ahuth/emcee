require 'test_helper'
require 'emcee/processors/import_processor'
require 'emcee/processors/script_processor'
require 'emcee/processors/stylesheet_processor'

require 'coffee-rails'
require 'sass'

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

class ProcessorsTest < ActiveSupport::TestCase
  setup do
    @context = ContextStub.new
    @body = <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    EOS
  end

  test "processing imports should work" do
    processor = Emcee::ImportProcessor.new(@context)
    processed = processor.process(@body)

    assert_equal 1, @context.assets.length
    assert_equal "/test.html", @context.assets[0]
    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    EOS
  end

  test "processing stylesheets should work" do
    processor = Emcee::StylesheetProcessor.new(@context)
    processed = processor.process(@body)

    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <style>/* contents */</style>
      <script src="test.js"></script>
      <p>test</p>
    EOS
  end

  test "processing scripts should work" do
    processor = Emcee::ScriptProcessor.new(@context)
    processed = processor.process(@body)

    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script>/* contents */</script>
      <p>test</p>
    EOS
  end

  test "processing sass stylesheets should work" do
    @body.gsub!("test.css", "test.css.scss")
    processor = Emcee::StylesheetProcessor.new(@context)
    processed = processor.process(@body)

    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <style>/* contents */</style>
      <script src="test.js"></script>
      <p>test</p>
    EOS
  end

  test "processing CoffeeScript should work" do
    @body.gsub!("test.js", "test.js.coffee")
    processor = Emcee::ScriptProcessor.new(@context)
    processed = processor.process(@body)

    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script>/* contents */</script>
      <p>test</p>
    EOS
  end
end
