require 'nokogiri'

module Emcee
  # ImportProcessor scans a file for html imports and adds them to the current
  # required assets.
  class ImportProcessor
    def initialize(context)
      @context = context
      @directory = File.dirname(context.pathname)
    end

    def process(data)
      doc = Nokogiri::HTML.fragment(data)
      require_assets(doc)
      remove_imports(doc)
      unescape(doc.to_s.lstrip)
    end

    private

    def require_assets(doc)
      doc.css("link[rel='import']").each do |node|
        path = File.absolute_path(node.attribute("href"), @directory)
        @context.require_asset(path)
      end
    end

    def remove_imports(doc)
      doc.css("link[rel='import']").each do |node|
        node.remove
      end
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
