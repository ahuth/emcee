module Emcee
  module Processors
    # HtmlProcessor processes html files by doing 4 things:
    #
    # 1. Stripping out asset pipeline directives and processing the associated
    #    files.
    # 2. Stripping out html imports and processing those files.
    # 3. Stripping out external stylesheet includes, and inlining those sheets
    #    where they were called.
    # 4. Stripping out external script tags, and inlining those scripts where
    #    they were called.
    #
    # It inherits from Sprocket::DirectiveProcessor, which does most of the
    # work for us.
    #
    class HtmlProcessor < Sprockets::DirectiveProcessor
      # Matches the entire header/directive block. This is everything from the
      # top of the file, enclosed in html comments.
      #
      # ---
      #
      # \A                matches the beginning of the string
      # (?m:\s*)          matches whitespace, including \n
      # (<!--(?m:.*?)-->) matches html comments and their content
      #
      HEADER_PATTERN = /\A((?m:\s*)(<!--(?m:.*?)-->))+/

      # Matches the an asset pipeline directive.
      #
      #   *= require_tree .
      #
      # ---
      #
      # ^         matches the beginning of the line
      # \W*       matches any non-word character, zero or more times
      # =         matches =, obviously
      # \s*       matches any whitespace character, zero or more times
      # (\w+.*?)  matches a group of characters, starting with a letter or number
      # $         matches the end of the line
      #
      DIRECTIVE_PATTERN = /^\W*=\s*(\w+.*?)$/

      # Match an html import tag.
      #
      #   <link rel="import" href="example.html">
      #
      IMPORT_PATTERN = /^<link .*rel=["']import["'].*>$/

      # Match a stylesheet link tag.
      #
      #   <link rel="stylesheet" href="example.css">
      #
      STYLESHEET_PATTERN = /^ +<link .*rel=["']stylesheet["'].*>$/

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

      # Render takes the actual text of the file and does our processing to it.
      # This is based on the standard render method on Sprockets's
      # DirectiveProcessor.
      #
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
        # Scan the body for html imports. If any are found, tell sprockets to
        # require their files like we would for a directive.
        def process_imports
          body.scan(IMPORT_PATTERN) do |import_tag|
            if path = import_tag[HREF_PATH_PATTERN, :path]
              absolute_path = File.absolute_path(path, @directory)
              context.require_asset(absolute_path)
            end
          end

          @body.gsub!(IMPORT_PATTERN, "")
        end

        # Scan the body for external stylesheet references. If any are found,
        # inline the files in place of the references.
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

        # Scan the body for external script references. If any are found, inline
        # the files in place of the references.
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
