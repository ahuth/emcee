require 'nokogumbo'

module Emcee
  # Document is responsible for parsing HTML and handling interaction with the
  # resulting document.
  class Document
    def initialize(data)
      @doc = Nokogiri::HTML5.parse("<html><body>#{data}</body></html>")
    end

    def create_node(type, content)
      node = Nokogiri::XML::Node.new(type, @doc)
      node.content = content
      node
    end

    def to_s
      body = @doc.at("body")
      content = stringify(body).lstrip
      unescape(content)
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

    # Unescape html entities and other special characters, such as &, {, and }.
    def unescape(content)
      unescaped = CGI.unescapeHTML(content)
      URI.unescape(unescaped)
    end

    # Convert a document into a string. While doing so, prevent 'selected'
    # attributes from having their value removed, and try to make valid html5.
    def stringify(doc)
      content = doc.children.to_s
      fixed = fix_closed_link_tags(content)
      fix_closed_script_tags(fixed)
    end

    def fix_closed_link_tags(content)
      closed_tag = /<link (.*)\/>/
      unclosed = '<link \1>'
      content.gsub(closed_tag, unclosed)
    end

    def fix_closed_script_tags(content)
      closed_tag = /<script (.*)\/>/
      unclosed = '<script \1></script>'
      content.gsub(closed_tag, unclosed)
    end
  end
end
