require 'nokogiri'

module Emcee
  # ScriptProcessor scans a document for external script references and inlines
  # them into the current document.
  class ScriptProcessor
    def initialize(context)
      @context = context
      @directory = File.dirname(context.pathname)
    end

    def process(data)
      doc = Nokogiri::HTML.fragment(data)
      inline_scripts(doc)
      doc.to_s
    end

    private

    def inline_scripts(doc)
      doc.css("script").each do |node|
        path = absolute_path(node.attribute("src"))
        content = @context.evaluate(path)
        script = create_script(doc, content)
        node.replace(script)
      end
    end

    def absolute_path(path)
      File.absolute_path(path, @directory)
    end

    def create_script(doc, content)
      script = Nokogiri::XML::Node.new("script", doc)
      script.content = content
      script
    end
  end
end
