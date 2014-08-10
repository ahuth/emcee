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
      unescape(replace_html_with_xhtml)
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

    def to_html
      doc.at("body").children.to_html.lstrip
    end

    def selected
      doc.css("*[selected]")
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

    # Take the html string and replace any elements that have a 'selected'
    # attribute with their xhtml string.
    def replace_html_with_xhtml
      selected.reduce(to_html) do |output, node|
        output.gsub(node.to_html, node.to_xhtml)
      end
    end
  end
end
