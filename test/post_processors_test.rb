require 'test_helper'
require 'emcee/post_processors/import_processor'
require 'emcee/post_processors/script_processor'
require 'emcee/post_processors/stylesheet_processor'
require 'emcee/document'

# Create a stub of our asset resolver, so we can test if we're sending the
# correct messages to it.
class ResolverStub
  attr_reader :assets

  def initialize
    @assets = []
  end

  def directory
    "/"
  end

  def require_asset(asset)
    @assets << asset
  end

  def evaluate(path)
    "/* contents */"
  end
end

class PostProcessorsTest < ActiveSupport::TestCase
  setup do
    @resolver = ResolverStub.new
    @body = <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    EOS
    @doc = Emcee::Document.new(@body)
  end

  test "processing imports should work" do
    processor = Emcee::PostProcessors::ImportProcessor.new(@resolver)
    processed = processor.process(@doc).to_s

    assert_equal 1, @resolver.assets.length
    assert_equal "/test.html", @resolver.assets[0]
    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    EOS
  end

  test "processing stylesheets should work" do
    processor = Emcee::PostProcessors::StylesheetProcessor.new(@resolver)
    processed = processor.process(@doc).to_s

    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <style>/* contents */</style>
      <script src="test.js"></script>
      <p>test</p>
    EOS
  end

  test "processing scripts should work" do
    processor = Emcee::PostProcessors::ScriptProcessor.new(@resolver)
    processed = processor.process(@doc).to_s

    assert_equal processed, <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script>/* contents */</script>
      <p>test</p>
    EOS
  end
end
