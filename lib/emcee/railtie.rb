require "emcee/pre_processors/directive_processor"
require "emcee/post_processors/import_processor"
require "emcee/post_processors/script_processor"
require "emcee/post_processors/stylesheet_processor"
require "emcee/compressors/html_compressor"

module Emcee
  class Railtie < Rails::Railtie
    initializer :add_asset_paths do |app|
      app.assets.paths.unshift(Rails.root.join("vendor", "assets", "components"))
    end

    initializer :add_preprocessors do |app|
      app.assets.register_mime_type "text/html", ".html"
      app.assets.register_preprocessor "text/html", DirectiveProcessor
    end

    initializer :add_postprocessors do |app|
      app.assets.register_postprocessor "text/html", :import_processor do |context, data|
        ImportProcessor.new(context).process(data)
      end
      app.assets.register_postprocessor "text/html", :script_processor do |context, data|
        ScriptProcessor.new(context).process(data)
      end
      app.assets.register_postprocessor "text/html", :stylesheet_processor do |context, data|
        StylesheetProcessor.new(context).process(data)
      end
    end

    initializer :add_compressors do |app|
      app.assets.register_bundle_processor "text/html", :html_compressor do |context, data|
        HtmlCompressor.new.compress(data)
      end
    end
  end
end
