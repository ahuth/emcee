require 'test_helper'
require 'emcee/node.rb'

# Create a stub of the native nodes used by the html parser, so we can test if
# we're sending the correct messages to it.
class ParserNodeStub
  attr_reader :removed, :replaced

  def initialize
    @attributes = { href: "test.css" }
  end

  def attribute(name)
    @attributes[name.to_sym]
  end

  def remove
    @removed = true
  end

  def replace(new_node)
    @replaced = true
  end

  def document
    Nokogiri::HTML::Document.new
  end
end

class NodeTest < ActiveSupport::TestCase
  setup do
    @parser_node = ParserNodeStub.new
    @node = Emcee::Node.new(@parser_node)
  end

  test "should have path" do
    assert_equal "test.css", @node.path
  end

  test "should have remove method" do
    @node.remove
    assert @parser_node.removed
  end

  test "should have replace method" do
    new_content = "/* test */"
    @node.replace("style", new_content)
    assert @parser_node.replaced
  end
end
