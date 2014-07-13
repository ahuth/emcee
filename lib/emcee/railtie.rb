require "emcee/pre_processors/directive_processor"
require "emcee/post_processors/import_processor"
require "emcee/post_processors/script_processor"
require "emcee/post_processors/stylesheet_processor"
require "emcee/compressors/html_compressor"
require "emcee/documents/html_document"

module Emcee
  class Railtie < Rails::Railtie
    initializer :add_asset_paths do |app|
      app.assets.paths.unshift(Rails.root.join("vendor", "assets", "components"))
    end

    initializer :add_preprocessors do |app|
      app.assets.register_mime_type "text/html", ".html"
      app.assets.register_preprocessor "text/html", Emcee::PreProcessors::DirectiveProcessor
    end

    initializer :add_postprocessors do |app|
      app.assets.register_postprocessor "text/html", :web_components do |context, data|
        doc = Emcee::Documents::HtmlDocument.new(data)
        Emcee::PostProcessors::ImportProcessor.new(context).process(doc)
        Emcee::PostProcessors::ScriptProcessor.new(context).process(doc)
        Emcee::PostProcessors::StylesheetProcessor.new(context).process(doc)
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
