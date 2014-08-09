require 'test_helper'
require 'emcee/node.rb'

class NodeTest < ActiveSupport::TestCase
  setup do
    @body = "<link rel=\"stylesheet\" href=\"test.css\">"
    @document = Nokogiri::HTML.fragment(@body)
    @parser_node = @document.children.first
    @node = Emcee::Node.new(@parser_node)
  end

  test "should have path" do
    assert_equal "test.css", @node.path.to_s
  end

  test "should remove itself" do
    @node.remove
    assert_equal 0, @document.children.length
  end

  test "can be replaced by a <style>" do
    new_content = "/* test */"
    @node.replace("style", new_content)
    assert_equal "<style>/* test */</style>", @document.to_s
  end

  test "can be replaced by a <script>" do
    new_content = "/* test */"
    @node.replace("script", new_content)
    assert_equal "<script>/* test */</script>", @document.to_s
  end
end
