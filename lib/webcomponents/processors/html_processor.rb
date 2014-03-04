module Webcomponents
  module Processors
    class HtmlProcessor < Sprockets::DirectiveProcessor
      # \A                matches the beginning of the string
      # (?m:\s*)          matches whitespace, including \n
      # (<!--(?m:.*?)-->) matches html comments and their content
      HEADER_PATTERN = /\A((?m:\s*)(<!--(?m:.*?)-->))+/

      # ^         matches the beginning of the line
      # \W*       matches any non-word character, zero or more times
      # =         matches =, obviously
      # \s*       matches any whitespace character, zero or more times
      # (\w+.*?)  matches a group of characters, starting with a letter or number
      DIRECTIVE_PATTERN = /^\W*=\s*(\w+.*?)$/

      # Match an html import tag.
      IMPORT_PATTERN = /^<link .*rel=["']import["'].*>$/

      # Match a stylesheet link tag.
      STYLESHEET_PATTERN = /^ +<link .*rel=["']stylesheet["'].*>$/

      # Match a script tag.
      SCRIPT_PATTERN = /^ *<script .*src=["'].+\.js["']><\/script>$/

      # Match the path from the href attribute of an html import.
      HREF_PATH_PATTERN = /href=["'](?<path>[\w\.\/-]+)["']/

      # Match the source path from a script tag.
      SRC_PATH_PATTERN = /src=["'](?<path>[\w\.\/-]+)["']/

      def render(context, locals)
        @context = context
        @pathname = context.pathname
        @directory = File.dirname(@pathname)

        @header  = data[HEADER_PATTERN, 0] || ""
        @body    = $' || data
        # Ensure body ends in a new line
        @body += "\n" if @body != "" && @body !~ /\n\Z/m

        @included_pathnames = []

        @result = ""
        @result.force_encoding(body.encoding)

        @has_written_body = false

        process_directives
        process_imports
        process_stylesheets
        process_scripts
        process_source

        @result
      end

      protected
        def process_imports
          body.scan(IMPORT_PATTERN) do |import_tag|
            if path = import_tag[HREF_PATH_PATTERN, :path]
              absolute_path = File.absolute_path(path, @directory)
              context.require_asset(absolute_path)
            end
          end

          @body.gsub!(IMPORT_PATTERN, "")
        end

        def process_stylesheets
          to_inline = []

          body.scan(STYLESHEET_PATTERN) do |stylesheet_tag|
            if path = stylesheet_tag[HREF_PATH_PATTERN, :path]
              absolute_path = File.absolute_path(path, @directory)
              stylesheet_contents = File.read(absolute_path)
              to_inline << [stylesheet_tag, "<style>\n" + stylesheet_contents + "</style>\n"]
            end
          end

          to_inline.each do |(tag, contents)|
            @body.gsub!(tag, contents)
          end
        end

        def process_scripts
          to_inline = []

          body.scan(SCRIPT_PATTERN) do |script_tag|
            if path = script_tag[SRC_PATH_PATTERN, :path]
              absolute_path = File.absolute_path(path, @directory)
              script_contents = File.read(absolute_path)
              to_inline << [script_tag, "<script>\n" + script_contents + "</script>\n"]
            end
          end

          to_inline.each do |(tag, contents)|
            @body.gsub!(tag, contents)
          end
        end
    end
  end
end
