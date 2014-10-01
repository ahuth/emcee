require 'test_helper'
require 'emcee/document'

class DocumentTest < ActiveSupport::TestCase
  setup do
    @body = <<-EOS.strip_heredoc
      <link rel="import" href="test1.html">
      <link rel="stylesheet" href="test1.css">
      <script src="test1.js"></script>
      <link rel="import" href="test2.html">
    EOS
    @doc = Emcee::Document.new(@body)
  end

  test "converts itself into a string" do
    assert_equal @body, @doc.to_s
  end

  test "can access html imports" do
    assert_equal 2, @doc.html_imports.length
  end

  test "can access scripts" do
    assert_equal 1, @doc.script_references.length
  end

  test "can access stylesheets" do
    assert_equal 1, @doc.style_references.length
  end

  test "optional attribute syntax should not be removed" do
    body = '<p hidden?="test">hidden</p>'
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end

  test "the selected attribute should be rendered correctly" do
    body = '<p selected="selected">test</p>'
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end

  test "ampersands, spaces, and curly-brackets should be unescaped" do
    body = '<p test="{{ & }}"></p>'
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end

  test "escaped single quotes in JavaScript should not be unescaped" do
    body = "<script>var test = '&#39;';</script>"
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end

  test "escaped double quotes in JavaScript should not be unescaped" do
    body = '<script>var test = "&#34;";</script>'
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end

  test "curly brackets in src attributes should be unescaped" do
    body = '<core-icon src="{{iconSrc}}"></core-icon>'
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end
end
