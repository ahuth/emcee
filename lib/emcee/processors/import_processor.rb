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
          path = absolute_path(node.href)
          @resolver.require_asset(path)
        end
      end

      def remove_imports(doc)
        doc.html_imports.each do |node|
          node.remove
        end
      end

      def absolute_path(path)
        File.absolute_path(path, @resolver.directory)
      end
    end
  end
end
