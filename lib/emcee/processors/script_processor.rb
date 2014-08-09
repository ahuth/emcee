module Emcee
  module Processors
    # ScriptProcessor scans a document for external script references and inlines
    # them into the current document.
    class ScriptProcessor
      attr_reader :resolver
      private :resolver

      def initialize(resolver)
        @resolver = resolver
      end

      def process(doc)
        inline_scripts(doc)
        doc
      end

      private

      def inline_scripts(doc)
        doc.script_references.each do |node|
          path = resolver.absolute_path(node.path)
          return unless resolver.should_inline?(path)
          content = resolver.evaluate(path)
          node.replace("script", content)
        end
      end
    end
  end
end
