module Emcee
  module Processors
    module Includes
      # Match an html import tag.
      #
      #   <link rel="import" href="assets/example.html">
      #
      IMPORT_PATTERN = /^\s*<link .*rel=["']import["'].*>$/

      # Scan the body for html imports. If any are found, tell sprockets to
      # require their files like we would for a directive. Then remove the
      # imports and return the new body.
      def process_imports(body, context, directory)
        body.scan(IMPORT_PATTERN) do |import_tag|
          if path = import_tag[HREF_PATH_PATTERN, :path]
            absolute_path = File.absolute_path(path, directory)
            context.require_asset(absolute_path)
          end
        end

        body.gsub(IMPORT_PATTERN, "")
      end
    end
  end
end
