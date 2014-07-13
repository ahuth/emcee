require 'test_helper'
require 'emcee/post_processors/import_processor'
require 'emcee/post_processors/script_processor'
require 'emcee/post_processors/stylesheet_processor'
require 'emcee/documents/html_document'

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

class PostProcessorsTest < ActiveSupport::TestCase
  setup do
    @context = ContextStub.new
    @body = <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    EOS
    @doc = Emcee::Documents::HtmlDocument.new(@body)
  end

  test "processing imports should work" do
    processor = Emcee::PostProcessors::ImportProcessor.new(@context)
    processed = processor.process(@doc).to_s

    assert_equal 1, @context.assets.length
    assert_equal "/test.html", @context.assets[0]
    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    EOS
  end

  test "processing stylesheets should work" do
    processor = Emcee::PostProcessors::StylesheetProcessor.new(@context)
    processed = processor.process(@doc).to_s

    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <style>/* contents */</style>
      <script src="test.js"></script>
      <p>test</p>
    EOS
  end

  test "processing scripts should work" do
    processor = Emcee::PostProcessors::ScriptProcessor.new(@context)
    processed = processor.process(@doc).to_s

    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script>/* contents */</script>
      <p>test</p>
    EOS
  end
end
