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
      include Emcee::Processors::Includes
      protected :process_imports
      protected :process_stylesheets
      protected :process_scripts

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
        @body = process_imports(@body, @context, @directory)
        @body = process_stylesheets(@body, @directory)
        @body = process_scripts(@body, @directory)
        process_source

        @result
      end
    end
  end
end
