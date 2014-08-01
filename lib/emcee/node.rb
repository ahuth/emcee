module Emcee
  # Document is responsible for interacting with individual html nodes that
  # make up the parsed document.
  class Node
    def initialize(parser_node)
      @parser_node = parser_node
    end

    def href
      @parser_node.attribute("href")
    end

    def src
      @parser_node.attribute("src")
    end

    def remove
      @parser_node.remove
    end

    def replace(new_node)
      @parser_node.replace(new_node.parser_node)
    end

    protected

    attr_reader :parser_node
  end
end
