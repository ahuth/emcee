require "emcee/node"
require "nokogumbo"

module Emcee
  # Document is responsible for parsing HTML and handling interaction with the
  # resulting document.
  class Document
    def initialize(data)
      @doc = Nokogiri::HTML5.parse("<html><body>#{data}</body></html>")
    end

    def to_s
      # Make an html string. To prevent 'selected' attributes from being
      # removed, use xhtml for nodes with them.
      html = htmlify_except(selected)
      unescape(html)
    end

    def html_imports
      wrap_nodes(@doc.css("link[rel='import']"))
    end

    def script_references
      wrap_nodes(@doc.css("script[src]"))
    end

    def style_references
      wrap_nodes(@doc.css("link[rel='stylesheet']"))
    end

    private

    # Get the html content of the document as a string.
    def to_html
      @doc.at("body").children.to_html.lstrip
    end

    # Get a list of nodes with a 'selected' attribute.
    def selected
      @doc.css("*[selected]")
    end

    # Wrap a list of parsed nodes in our own Node class.
    def wrap_nodes(nodes)
      nodes.map { |node| Emcee::Node.new(node) }
    end

    # Unescape & characters.
    def unescape(content)
      content.gsub("&amp;", "&")
    end

    # Generate an html string for the current document, but replace the provided
    # nodes with their xhtml strings.
    def htmlify_except(nodes)
      nodes.reduce(to_html) do |output, node|
        output.gsub(node.to_html, node.to_xhtml)
      end
    end
  end
end
