require 'nokogiri'
require 'uri'

module Emcee
  module Documents
    # HtmlDocument presents a stable interface for an HTML document to the
    # processors.
    class HtmlDocument
      attr_reader :doc

      def initialize(data)
        @doc = Nokogiri::HTML.fragment(data)
      end

      def create_node(type, content)
        node = Nokogiri::XML::Node.new(type, @doc)
        node.content = content
        node
      end

      def to_s
        URI.unescape(@doc.to_s.lstrip)
      end

      def css(*args)
        @doc.css(*args)
      end
    end
  end
end
