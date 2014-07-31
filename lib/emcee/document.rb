require 'nokogumbo'

module Emcee
  # Document is responsible for parsing HTML and handling interaction with the
  # resulting document.
  class Document
    def initialize(data)
      @doc = Nokogiri::HTML5.parse("<html><body>#{data}</body></html")
    end

    def create_node(type, content)
      node = Nokogiri::XML::Node.new(type, @doc)
      node.content = content
      node
    end

    def to_s
      body = @doc.at("body")
      content = stringify(body).lstrip
      unescaped = CGI.unescapeHTML(content)
      URI.unescape(unescaped)
    end

    def html_imports
      @doc.css("link[rel='import']")
    end

    def script_references
      @doc.css("script[src]")
    end

    def style_references
      @doc.css("link[rel='stylesheet']")
    end

    private

    def stringify(doc)
      doc.children.map do |node|
        return node.to_xhtml if has_selected_attribute?(node)
        node.to_html
      end.join
    end

    def has_selected_attribute?(node)
      node.attributes.has_key?("selected")
    end
  end
end
