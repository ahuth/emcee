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
      doc = Nokogiri::HTML("<body>#{data}</body>")
      require_assets(doc)
      remove_imports(doc)
      doc.at("body").children.to_s.lstrip
    end

    private

    def require_assets(doc)
      doc.css("link[rel='import']").each do |node|
        path = File.absolute_path(node.attribute("href"), @directory)
        @context.require_asset(path)
      end
    end

    def remove_imports(doc)
      doc.search("link[rel='import']").each do |node|
        node.remove
      end
    end
  end
end
