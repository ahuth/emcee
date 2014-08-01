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

  test "nodes can be removed" do
    assert_difference "@doc.html_imports.length", -1 do
      @doc.html_imports.first.remove
    end
  end

  test "nodes can access their attributes" do
    assert_equal "test1.html", @doc.html_imports.first.href.to_s
    assert_equal "test1.js", @doc.script_references.first.src.to_s
    assert_equal "test1.css", @doc.style_references.first.href.to_s
  end

  test "nodes can be replaced" do
    node = @doc.create_node("script", "test")
    @doc.html_imports.first.replace(node)

    correct = <<-EOS.strip_heredoc
      <script>test</script>
      <link rel="stylesheet" href="test1.css">
      <script src="test1.js"></script>
      <link rel="import" href="test2.html">
    EOS

    assert_equal correct, @doc.to_s
  end

  test "optional attribute syntax should not be removed" do
    body = "<p hidden?=\"{{ hidden }}\">hidden</p>"
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end

  test "special characters should be rendered correctly" do
    body = "<p src=\"{{ src }}\">test</p>"
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end

  test "the selected attribute should be rendered correctly" do
    body = "<p selected=\"{{ selected }}\">test</p>"
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end

  test "nested selected attributes should be rendered correctly" do
    body = <<-EOS.strip_heredoc
      <div>
        <p selected="{{ selected }}">test</p>
      </div>
    EOS
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end

  test "html entities should be unescaped" do
    url = "//fonts.googleapis.com/css?family=RobotoDraft&lang=en"
    body = "<link rel=\"stylesheet\" href=\"#{url}\">"
    doc = Emcee::Document.new(body)
    assert_equal body, doc.to_s
  end
end
