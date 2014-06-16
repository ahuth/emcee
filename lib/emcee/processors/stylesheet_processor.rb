module Emcee
  # StylesheetProcessor scans a document for external stylesheet references and
  # inlines them into the current document.
  class StylesheetProcessor
    # Match a stylesheet link tag.
    #
    #   <link rel="stylesheet" href="assets/example.css">
    #
    STYLESHEET_PATTERN = /^\s*<link .*rel=["']stylesheet["'].*>$/

    # Match the path from the href attribute of an html import or stylesheet
    # include tag. Captures the actual path.
    #
    #   href="/assets/example.css"
    #
    HREF_PATH_PATTERN = /href=["'](?<path>[\w\.\/-]+)["']/

    # Match the indentation whitespace of a line
    #
    INDENT_PATTERN = /^(?<indent>\s*)/

    def process(context, data, directory)
      to_inline = find_stylesheet_tags(data, directory)
      inline_styles(data, to_inline)
    end

    private

    def read_file(path)
      File.read(path)
    end

    def find_stylesheet_tags(data, directory)
      data.scan(STYLESHEET_PATTERN).reduce([]) do |output, style_tag|
        path = style_tag[HREF_PATH_PATTERN, :path]
        return output unless path

        indent = style_tag[INDENT_PATTERN, :indent] || ""
        absolute_path = File.absolute_path(path, directory)
        style_contents = read_file(absolute_path)

        output << [style_tag, "#{indent}<style>#{style_contents}\n#{indent}</style>"]
      end
    end

    def inline_styles(data, scripts)
      scripts.reduce(data) do |output, (tag, contents)|
        output.gsub(tag, contents)
      end
    end
  end
end
