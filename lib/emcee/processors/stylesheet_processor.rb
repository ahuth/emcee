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
      tags = find_tags(data)
      paths = get_paths(tags)
      indents = get_indents(tags)
      contents = get_contents(paths, directory)
      inline_styles(data, tags, indents, contents)
    end

    private

    def read_file(path)
      File.read(path)
    end

    def find_tags(data)
      data.scan(STYLESHEET_PATTERN).map do |tag|
        tag
      end
    end

    def get_paths(tags)
      tags.map do |tag|
        tag[HREF_PATH_PATTERN, :path]
      end
    end

    def get_indents(tags)
      tags.map do |tag|
        tag[INDENT_PATTERN, :indent] || ""
      end
    end

    def get_contents(paths, directory)
      paths.map do |path|
        absolute_path = File.absolute_path(path, directory)
        read_file(absolute_path)
      end
    end

    def inline_styles(data, tags, indents, contents)
      tags.each_with_index do |tag, i|
        indent = indents[i]
        content = contents[i]
        data.gsub!(tag, "#{indent}<style>#{content}\n#{indent}</style>")
      end
      data
    end
  end
end
