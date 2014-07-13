require 'nokogiri'
require 'uri'

module Emcee
  module Documents
    # HtmlDocument presents a stable interface for an HTML document to the
    # processors.
    class HtmlDocument
      def initialize(data)
        data = wrap_templates(data)
        @doc = Nokogiri::HTML.fragment(data)
      end

      def create_node(type, content)
        node = Nokogiri::XML::Node.new(type, @doc)
        node.content = content
        node
      end

      def to_s
        data = URI.unescape(@doc.to_s.lstrip)
        unwrap_templates(data)
      end

      def css(*args)
        @doc.css(*args)
      end

      private

      def wrap_templates(data)
        data.gsub(/<template>/, "<template><script>'").gsub(/<\/template>/, "'</script></template>")
      end

      def unwrap_templates(data)
        data.gsub(/<template><script>'/, "<template>").gsub(/'<\/script><\/template>/, "</template>")
      end
    end
  end
end
