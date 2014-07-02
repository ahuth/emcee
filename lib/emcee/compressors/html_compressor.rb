module Emcee
  module Compressors
    # HtmlCompressor is a very basic compressor that removes blank lines and
    # comments from an HTML file.
    class HtmlCompressor
      HTML_COMMENTS     = /\<!\s*--(?:.*?)(?:--\s*\>)/m
      JS_MULTI_COMMENTS = /\/\*(?:.*?)\*\//m
      JS_COMMENTS       = /^\s*\/\/.*$/
      BLANK_LINES       = /^[\s]*$\n/

      def compress(string)
        ops = [HTML_COMMENTS, JS_MULTI_COMMENTS, JS_COMMENTS, BLANK_LINES]

        ops.reduce(string) do |output, op|
          output.gsub(op, "")
        end
      end
    end
  end
end
