module Emcee
  module Processors
    # StylesheetProcessor scans a document for external stylesheet references and
    # inlines them into the current document.
    class StylesheetProcessor
      def initialize(resolver)
        @resolver = resolver
      end

      def process(doc)
        inline_styles(doc)
        doc
      end

      private

      def inline_styles(doc)
        doc.style_references.each do |node|
          path = absolute_path(node.attribute("href"))
          return unless @resolver.should_inline?(path)
          content = @resolver.evaluate(path)
          style = doc.create_node("style", content)
          node.replace(style)
        end
      end

      def absolute_path(path)
        File.absolute_path(path, @resolver.directory)
      end
    end
  end
end
