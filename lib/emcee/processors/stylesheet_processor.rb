require 'nokogiri'

module Emcee
  # StylesheetProcessor scans a document for external stylesheet references and
  # inlines them into the current document.
  class StylesheetProcessor
    def initialize(context)
      @context = context
      @directory = File.dirname(context.pathname)
    end

    def process(data)
      doc = Nokogiri::HTML.fragment(data)
      inline_styles(doc)
      unescape(doc.to_s)
    end

    private

    def inline_styles(doc)
      doc.css("link[rel='stylesheet']").each do |node|
        path = absolute_path(node.attribute("href"))
        content = @context.evaluate(path)
        style = create_style(doc, content)
        node.replace(style)
      end
    end

    def absolute_path(path)
      File.absolute_path(path, @directory)
    end

    def create_style(doc, content)
      node = Nokogiri::XML::Node.new("style", doc)
      node.content = content
      node
    end

    def unescape(html)
      chars = {
        "{" => "%7B",
        " " => "%20",
        "}" => "%7D"
        }
      chars.reduce(html) do |output, (key, value)|
        output.gsub(value, key)
      end
    end
  end
end
