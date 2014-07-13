module Emcee
  module PostProcessors
    # ScriptProcessor scans a document for external script references and inlines
    # them into the current document.
    class ScriptProcessor
      def initialize(context)
        @context = context
        @directory = File.dirname(context.pathname)
      end

      def process(doc)
        inline_scripts(doc)
        doc
      end

      private

      def inline_scripts(doc)
        doc.css("script[src]").each do |node|
          path = absolute_path(node.attribute("src"))
          content = @context.evaluate(path)
          script = doc.create_node("script", content)
          node.replace(script)
        end
      end

      def absolute_path(path)
        File.absolute_path(path, @directory)
      end
    end
  end
end
