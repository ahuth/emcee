module Emcee
  # ImportProcessor scans a file for html imports and adds them to the current
  # required assets.
  class ImportProcessor
    # Match an html import tag.
    #
    #   <link rel="import" href="assets/example.html">
    #
    IMPORT_PATTERN = /^\s*<link .*rel=["']import["'].*>$/

    # Match the path from the href attribute of an html import or stylesheet
    # include tag. Captures the actual path.
    #
    #   href="/assets/example.css"
    #
    HREF_PATH_PATTERN = /href=["'](?<path>[\w\.\/-]+)["']/

    def initialize(context, directory)
      @context = context
      @directory = directory
    end

    def process(data)
      require_assets(data)
      remove_imports(data)
    end

    private

    def require_assets(data)
      data.scan(IMPORT_PATTERN) do |import_tag|
        path = import_tag[HREF_PATH_PATTERN, :path]
        return unless path

        absolute_path = File.absolute_path(path, @directory)
        @context.require_asset(absolute_path)
      end
    end

    def remove_imports(data)
      data.gsub(IMPORT_PATTERN, "")
    end
  end
end
