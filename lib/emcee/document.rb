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

    def create_node(type, content)
      node = Nokogiri::XML::Node.new(type, doc)
      node.content = content
      Emcee::Node.new(node)
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

    # Unescape html entities and other special characters, such as &, {, and }.
    def unescape(content)
      unescaped = CGI.unescapeHTML(content)
      URI.unescape(unescaped)
    end

    # Convert a document into a string. For some reason, 'selected' attributes
    # have their values removed. Fix that by replacing their `to_html` output
    # with `to_xhtml`.
    def stringify(body)
      selected = body.css("*[selected]")
      content = body.children.to_html
      selected.reduce(content) do |output, node|
        output.gsub(node.to_html, node.to_xhtml)
      end
    end
  end
end
