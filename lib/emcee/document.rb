require 'nokogiri'

module Emcee
  # Document is responsible for parsing HTML and handling interaction with the
  # resulting document.
  class Document
    def initialize(data)
      @doc = Nokogiri::HTML.fragment(data)
    end

    def create_node(type, content)
      node = Nokogiri::XML::Node.new(type, @doc)
      node.content = content
      node
    end

    def to_s
      @doc.to_s.lstrip
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
  end
end
