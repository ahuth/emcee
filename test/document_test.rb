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
    assert_equal @doc.to_s, @body
  end

  test "can access html imports" do
    assert_equal @doc.html_imports.length, 2
  end

  test "can access scripts" do
    assert_equal @doc.script_references.length, 1
  end

  test "can access stylesheets" do
    assert_equal @doc.style_references.length, 1
  end

  test "nodes can be removed" do
    assert_difference "@doc.html_imports.length", -1 do
      @doc.html_imports.first.remove
    end
  end

  test "nodes can access their attributes" do
    assert_equal @doc.html_imports.first.attribute("href").to_s, "test1.html"
    assert_equal @doc.script_references.first.attribute("src").to_s, "test1.js"
    assert_equal @doc.style_references.first.attribute("href").to_s, "test1.css"
  end

  test "nodes can be created" do
    node = @doc.create_node("script", "test")
    assert_equal node.to_s, "<script>test</script>"
  end

  test "nodes can be replaced" do
    node = @doc.create_node("script", "test")
    @doc.html_imports.first.replace(node)

    assert_equal @doc.to_s, <<-EOS.strip_heredoc
      <script>test</script>
      <link rel="stylesheet" href="test1.css">
      <script src="test1.js"></script>
      <link rel="import" href="test2.html">
    EOS
  end

  test "optional attribute syntax should not be removed" do
    body = "<p hidden?=\"{{ hidden }}\">hidden</p>"
    doc = Emcee::Document.new(body)
    assert_equal doc.to_s, body
  end

  test "special characters should be rendered correctly" do
    body = "<p src=\"{{ src }}\">test</p>"
    doc = Emcee::Document.new(body)
    assert_equal doc.to_s, body
  end

  test "the selected attribute should be rendered correctly" do
    body = "<p selected=\"{{ selected }}\">test</p>"
    doc = Emcee::Document.new(body)
    assert_equal doc.to_s, body
  end

  test "nested selected attributes should be rendered correctly" do
    body = "<div><p selected=\"{{ selected }}\">test</p></div>"
    doc = Emcee::Document.new(body)
    assert_equal doc.to_s, body
  end

  test "html entities should be unescaped" do
    url = "//fonts.googleapis.com/css?family=RobotoDraft&lang=en"
    body = "<link rel=\"stylesheet\" href=\"#{url}\">"
    doc = Emcee::Document.new(body)
    assert_equal doc.to_s, body
  end
end
