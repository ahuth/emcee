require 'test_helper'
require 'emcee/processors/import_processor'
require 'emcee/processors/script_processor'
require 'emcee/processors/stylesheet_processor'
require 'emcee/document'

# Create a stub of our asset resolver, so we can test if we're sending the
# correct messages to it.
class ResolverStub
  attr_reader :asset_required

  def directory
    "/"
  end

  def require_asset(asset)
    @asset_required = true
  end

  def evaluate(path)
    "/* contents */"
  end

  def should_inline?(path)
    true
  end
end

class ProcessorsTest < ActiveSupport::TestCase
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
    processor = Emcee::Processors::ImportProcessor.new(@resolver)
    processed = processor.process(@doc).to_s

    test = <<-EOS.strip_heredoc
      <link rel="stylesheet" href="test.css">
      <script src="test.js"></script>
      <p>test</p>
    EOS

    assert @resolver.asset_required
    assert_equal test, processed
  end

  test "processing stylesheets should work" do
    processor = Emcee::Processors::StylesheetProcessor.new(@resolver)
    processed = processor.process(@doc).to_s

    test = <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <style>/* contents */</style>
      <script src="test.js"></script>
      <p>test</p>
    EOS

    assert_equal test, processed
  end

  test "processing scripts should work" do
    processor = Emcee::Processors::ScriptProcessor.new(@resolver)
    processed = processor.process(@doc).to_s

    test = <<-EOS.strip_heredoc
      <link rel="import" href="test.html">
      <link rel="stylesheet" href="test.css">
      <script>/* contents */</script>
      <p>test</p>
    EOS

    assert_equal test, processed
  end
end
