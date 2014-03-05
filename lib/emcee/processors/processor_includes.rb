module Emcee
  module Processors
    # This module has method definition that we will include into HtmlProcessor.
    #
    # We seperate these out to make them easier to test. Testing a class that inherits
    # from Sprockets::DirectiveProcessor (which our HtmlProcessor does) is not
    # straightforward.
    #
    module Includes
      # Match an html import tag.
      #
      #   <link rel="import" href="example.html">
      #
      IMPORT_PATTERN = /^ *<link .*rel=["']import["'].*>$/

      # Match a stylesheet link tag.
      #
      #   <link rel="stylesheet" href="example.css">
      #
      STYLESHEET_PATTERN = /^ *<link .*rel=["']stylesheet["'].*>$/

      # Match a script tag.
      #
      #   <script src="assets/example.js"></script>
      #
      SCRIPT_PATTERN = /^ *<script .*src=["'].+\.js["']><\/script>$/

      # Match the path from the href attribute of an html import or stylesheet
      # include tag. Captures the actual path.
      #
      #   href="/assets/example.css"
      #
      HREF_PATH_PATTERN = /href=["'](?<path>[\w\.\/-]+)["']/

      # Match the source path from a script tag. Captures the actual path.
      #
      #   src="/assets/example.js"
      #
      SRC_PATH_PATTERN = /src=["'](?<path>[\w\.\/-]+)["']/

      # Scan the body for html imports. If any are found, tell sprockets to
      # require their files like we would for a directive. Then remove the import.
      def process_imports(body, context, directory)
        body.scan(IMPORT_PATTERN) do |import_tag|
          if path = import_tag[HREF_PATH_PATTERN, :path]
            absolute_path = File.absolute_path(path, directory)
            context.require_asset(absolute_path)
          end
        end

        body.gsub(IMPORT_PATTERN, "")
      end

      # Scan the body for external stylesheet references. If any are found,
      # inline the files in place of the references.
      def process_stylesheets(body, directory)
        to_inline = []

        body.scan(STYLESHEET_PATTERN) do |stylesheet_tag|
          if path = stylesheet_tag[HREF_PATH_PATTERN, :path]
            absolute_path = File.absolute_path(path, directory)
            stylesheet_contents = File.read(absolute_path)
            to_inline << [stylesheet_tag, "<style>\n" + stylesheet_contents + "</style>\n"]
          end
        end

        to_inline.reduce(body) do |output, (tag, contents)|
          output.gsub(tag, contents)
        end
      end

      # Scan the body for external script references. If any are found, inline
      # the files in place of the references.
      def process_scripts(body, directory)
        to_inline = []

        body.scan(SCRIPT_PATTERN) do |script_tag|
          if path = script_tag[SRC_PATH_PATTERN, :path]
            absolute_path = File.absolute_path(path, directory)
            script_contents = File.read(absolute_path)
            to_inline << [script_tag, "<script>\n" + script_contents + "</script>\n"]
          end
        end

        to_inline.reduce(body) do |output, (tag, contents)|
          output.gsub(tag, contents)
        end
      end
    end
  end
end
