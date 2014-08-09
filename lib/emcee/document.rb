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
      body = doc.at("body")
      content = stringify(body).lstrip
      unescape(content)
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

    # Wrap a list of parsed nodes in our own Node class.
    def wrap_nodes(nodes)
      nodes.map { |node| Emcee::Node.new(node) }
    end

    # Unescape special characters such as &, {, and }.
    def unescape(content)
      unescaped = CGI.unescapeHTML(content)
      URI.unescape(unescaped)
    end

    # Convert nodes into a string. For some reason, 'selected' attributes have
    # their values removed. Fix that by replacing their `to_html` output with
    # `to_xhtml`.
    def stringify(parent)
      selected = parent.css("*[selected]")
      content = parent.children.to_html
      selected.reduce(content) do |output, node|
        output.gsub(node.to_html, node.to_xhtml)
      end
    end
  end
end
