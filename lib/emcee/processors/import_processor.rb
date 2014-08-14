module Emcee
  module Processors
    # ImportProcessor scans a file for html imports and adds them to the current
    # required assets.
    class ImportProcessor
      def initialize(resolver)
        @resolver = resolver
      end

      def process(doc)
        require_assets(doc)
        remove_imports(doc)
        doc
      end

      private

      def require_assets(doc)
        doc.html_imports.each do |node|
          path = @resolver.absolute_path(node.path)
          @resolver.require_asset(path)
        end
      end

      def remove_imports(doc)
        doc.html_imports.each do |node|
          node.remove
        end
      end
    end
  end
end
