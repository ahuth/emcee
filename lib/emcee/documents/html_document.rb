require 'nokogiri'

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
        data = @doc.to_s.lstrip
        unwrap_templates(data)
      end

      def css(*args)
        @doc.css(*args)
      end

      private

      # Prevent the content of <template> tags from being parsed. Wraps the
      # content in <script> tags.
      def wrap_templates(data)
        tags = /<template>(.+)<\/template>/m
        wrap = '<template><script>"\1"</script></template>'
        data.gsub(tags, wrap)
      end

      # Remove <script> tags wrapping the content of <template> tags.
      def unwrap_templates(data)
        tags = /<template><script>"(.+)"<\/script><\/template>/m
        unwrap = '<template>\1</template>'
        data.gsub(tags, unwrap)
      end
    end
  end
end
