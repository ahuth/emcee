require 'nokogumbo'

module Emcee
  # Document is responsible for parsing HTML and handling interaction with the
  # resulting document.
  class Document
    attr_reader :doc
    private :doc

    def initialize(data)
      @doc = Nokogiri::HTML5.parse("<html><body>#{data}</body></html>")
    end

    def to_s
      selected = doc.css("*[selected]")
      stringified = replace_html_with_xhtml(content, selected)
      unescape(stringified)
    end

    def html_imports
      wrap_nodes(doc.css("link[rel='import']"))
    end

    def script_references
      wrap_nodes(doc.css("script[src]"))
    end

    def style_references
      wrap_nodes(doc.css("link[rel='stylesheet']"))
    end

    private

    def content
      doc.at("body").children.to_html.lstrip
    end

    # Wrap a list of parsed nodes in our own Node class.
    def wrap_nodes(nodes)
      nodes.map { |node| Emcee::Node.new(node) }
    end

    # Unescape special characters such as &, {, and }.
    def unescape(content)
      unescaped = CGI.unescapeHTML(content)
      URI.unescape(unescaped)
    end

    # Replace the html of certain nodes with their xhtml representation. This
    # is to prevent 'selected' attributes from having their values removed.
    def replace_html_with_xhtml(content, nodes)
      nodes.reduce(content) do |output, node|
        output.gsub(node.to_html, node.to_xhtml)
      end
    end
  end
end
