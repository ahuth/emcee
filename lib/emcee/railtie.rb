require "emcee/directive_processor"
require "emcee/processors/import_processor"
require "emcee/processors/script_processor"
require "emcee/processors/stylesheet_processor"
require "emcee/compressors/html_compressor"
require "emcee/document"
require "emcee/resolver"

module Emcee
  class Railtie < Rails::Railtie
    initializer :add_asset_paths do |app|
      app.assets.paths.unshift(Rails.root.join("vendor", "assets", "components"))
    end

    initializer :add_preprocessors do |app|
      app.assets.register_mime_type "text/html", ".html"
      app.assets.register_preprocessor "text/html", Emcee::DirectiveProcessor
    end

    initializer :add_postprocessors do |app|
      app.assets.register_postprocessor "text/html", :web_components do |context, data|
        doc = Emcee::Document.new(data)
        resolver = Emcee::Resolver.new(context)
        Emcee::Processors::ImportProcessor.new(resolver).process(doc)
        Emcee::Processors::ScriptProcessor.new(resolver).process(doc)
        Emcee::Processors::StylesheetProcessor.new(resolver).process(doc)
        doc.to_s
      end
    end

    initializer :add_compressors do |app|
      app.assets.register_bundle_processor "text/html", :html_compressor do |context, data|
        Emcee::Compressors::HtmlCompressor.new.compress(data)
      end
    end
  end
end
