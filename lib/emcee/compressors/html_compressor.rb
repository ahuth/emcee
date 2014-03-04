module Emcee
  module Compressors
    # HtmlCompressor is our basic implementation of an html minifier. For
    # sprockets to use it, it must have a compress method that only accepts a
    # string and returns the compressed output.
    #
    # Our implementation only strips out html and javascript comments, and
    # removes blank lines.
    #
    class HtmlCompressor
      # Match html comments.
      #
      #   <!--
      #   Comments
      #   -->
      #
      HTML_COMMENTS = /\<!\s*--(?:.*?)(?:--\s*\>)/m

      # Match multi-line javascript/css comments.
      #
      #   /*
      #   Comments
      #   */
      #
      JS_MULTI_COMMENTS = /\/\*(?:.*?)\*\//m

      # Match single-line javascript comments.
      #
      #   // Comments
      #
      # This does not have the /m modifier, because we only want it to match a
      # single line at a time.
      #
      JS_COMMENTS = /\/\/.*$/

      # Match blank lines.
      BLANK_LINES = /^[\s]*$\n/

      # Remove comments and blank lines from our html.
      def compress(string)
        ops = [HTML_COMMENTS, JS_MULTI_COMMENTS, JS_COMMENTS, BLANK_LINES]

        ops.reduce(string) do |output, op|
          output.gsub(op, "")
        end
      end
    end
  end
end
