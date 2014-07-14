require 'test_helper'
require 'emcee/document'

class DocumentTest < ActiveSupport::TestCase
  setup do
    @body = <<-EOS.strip_heredoc
      <p>test1</p>
      <span class="test">test2</span>
      <p>test3</p>
    EOS
    @doc = Emcee::Document.new(@body)
  end

  test "converts itself into a string" do
    assert_equal @doc.to_s, @body
  end

  test "finds nodes via css selectors" do
    assert_equal @doc.css("p").length, 2
    assert_equal @doc.css("span").length, 1
    assert_equal @doc.css(".test").length, 1
  end

  test "nodes can be created" do
    node = @doc.create_node("span", "test3")
    assert_equal node.content, "test3"
  end

  test "nodes can be removed" do
    assert_difference "@doc.css('p').length", -1 do
      @doc.css("p").first.remove
    end
  end

  test "nodes can be replaced" do
    node = @doc.create_node("span", "test3")
    @doc.css("span").first.replace(node)
    assert_equal @doc.css("span").first, node
  end

  test "nodes can access their attributes" do
    node = @doc.css("span").first
    assert_equal node.attribute("class").value, "test"
  end

  test "malformed template tag content should not be corrected" do
    @body = <<-EOS.strip_heredoc
      <template>
        <p hidden?="{{ hidden }}">hidden</p>
      </template>
    EOS
    @doc = Emcee::Document.new(@body)
    assert_equal @doc.to_s, @body
  end
end
