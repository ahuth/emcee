module Webcomponents
  module Compressors
    class HtmlCompressor
      # Match html comments: <!-- comments -->
      HTML_COMMENTS = /\<!\s*--(?:.*?)(?:--\s*\>)/m

      # Match multi-line javascript/css comments: /* comments */
      JS_MULTI_COMMENTS = /\/\*(?:.*?)\*\//m

      # Match single-line javascript comments: // comments. Make sure this regex
      # does not have the /m modifier. We only want to match a single line at a
      # time.
      JS_COMMENTS = /\/\/.*$/

      # Match blank lines
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
