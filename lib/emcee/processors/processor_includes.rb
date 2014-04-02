module Emcee
  module Processors
    # This module defines methods that we will include into HtmlProcessor.
    #
    # Testing a class that inherits from Sprockets::DirectiveProcessor, which
    # HtmlProcessor does, is difficult. Seperating out these methods makes them
    # easy to unit test.
    #
    module Includes
      # Match an html import tag.
      #
      #   <link rel="import" href="assets/example.html">
      #
      IMPORT_PATTERN = /^\s*<link .*rel=["']import["'].*>$/

      # Match a stylesheet link tag.
      #
      #   <link rel="stylesheet" href="assets/example.css">
      #
      STYLESHEET_PATTERN = /^\s*<link .*rel=["']stylesheet["'].*>$/

      # Match a script tag.
      #
      #   <script src="assets/example.js"></script>
      #
      SCRIPT_PATTERN = /^\s*<script .*src=["'].+\.js["']><\/script>$/

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

      # Match the indentation whitespace of a line
      #
      INDENT_PATTERN = /^(?<indent>\s*)/

      # Return a file's contents as text. This is split out as a method so that
      # we can test the other methods in this module without actually reading from
      # the filesystem.
      def read_file(path)
        File.read(path)
      end

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

      # Scan the body for external script references. If any are found, inline
      # the files in place of the references and return the new body.
      def process_scripts(body, directory)
        to_inline = []

        body.scan(SCRIPT_PATTERN) do |script_tag|
          if path = script_tag[SRC_PATH_PATTERN, :path]

            indent = script_tag[INDENT_PATTERN, :indent] || ""

            absolute_path = File.absolute_path(path, directory)
            script_contents = read_file(absolute_path)

            to_inline << [script_tag, "#{indent}<script>#{script_contents}\n#{indent}</script>"]
          end
        end

        to_inline.reduce(body) do |output, (tag, contents)|
          output.gsub(tag, contents)
        end
      end

      # Scan the body for external stylesheet references. If any are found,
      # inline the files in place of the references and return the new body.
      def process_stylesheets(body, directory)
        to_inline = []

        body.scan(STYLESHEET_PATTERN) do |stylesheet_tag|
          if path = stylesheet_tag[HREF_PATH_PATTERN, :path]

            indent = stylesheet_tag[INDENT_PATTERN, :indent] || ""

            absolute_path = File.absolute_path(path, directory)
            stylesheet_contents = read_file(absolute_path)

            to_inline << [stylesheet_tag, "#{indent}<style>#{stylesheet_contents}\n#{indent}</style>"]
          end
        end

        to_inline.reduce(body) do |output, (tag, contents)|
          output.gsub(tag, contents)
        end
      end
    end
  end
end
