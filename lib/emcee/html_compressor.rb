module Emcee
  # HTML compressor that strips out comments and blank lines. For Sprockets to
  # use this, it must have a `compress` method that takes a string and returns
  # the compressed output.
  class HtmlCompressor
    HTML_COMMENTS     = /\<!\s*--(?:.*?)(?:--\s*\>)/m
    JS_MULTI_COMMENTS = /\/\*(?:.*?)\*\//m
    JS_COMMENTS       = /\/\/.*$/
    BLANK_LINES       = /^[\s]*$\n/

    def compress(string)
      ops = [HTML_COMMENTS, JS_MULTI_COMMENTS, JS_COMMENTS, BLANK_LINES]

      ops.reduce(string) do |output, op|
        output.gsub(op, "")
      end
    end
  end
end
