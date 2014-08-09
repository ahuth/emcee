module Emcee
  # Document is responsible for interacting with individual html nodes that
  # make up the parsed document.
  class Node
    attr_reader :parser_node
    protected :parser_node

    def initialize(parser_node)
      @parser_node = parser_node
    end

    def path
      href || src
    end

    def remove
      parser_node.remove
    end

    def replace(new_node)
      parser_node.replace(new_node.parser_node)
    end

    private

    def href
      parser_node.attribute("href")
    end

    def src
      parser_node.attribute("src")
    end
  end
end
