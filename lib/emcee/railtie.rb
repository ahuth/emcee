require "emcee/processors/directive_processor"
require "emcee/processors/import_processor"
require "emcee/processors/script_processor"
require "emcee/processors/stylesheet_processor"
require "emcee/html_compressor"

module Emcee
  class Railtie < Rails::Railtie
    initializer :add_html_processor do |app|
      app.assets.register_mime_type "text/html", ".html"
      app.assets.register_preprocessor "text/html", DirectiveProcessor
    end

    initializer :add_processors do |app|
      app.assets.register_postprocessor "text/html", :import_processor do |context, data|
        directory = File.dirname(context.pathname)
        ImportProcessor.new.process(context, data, directory)
      end
      app.assets.register_postprocessor "text/html", :script_processor do |context, data|
        directory = File.dirname(context.pathname)
        ScriptProcessor.new.process(context, data, directory)
      end
      app.assets.register_postprocessor "text/html", :stylesheet_processor do |context, data|
        directory = File.dirname(context.pathname)
        StylesheetProcessor.new.process(context, data, directory)
      end
    end

    initializer :add_html_compressor do |app|
      app.assets.register_bundle_processor "text/html", :html_compressor do |context, data|
        HtmlCompressor.new.compress(data)
      end
    end
  end
end

# Monkey patch Sprockets-rails so that loose html files are handled correctly.
#
# Not sure that modifying another gem's railtie is a good idea, but it works
# for now.
module Sprockets
  class Railtie
    # Remove the LOOSE_APP_ASSETS constant so we can modify it without Ruby
    # complaining.
    remove_const(:LOOSE_APP_ASSETS) if defined?(LOOSE_APP_ASSETS)

    # Add .html to the loose app assets file extensions.
    LOOSE_APP_ASSETS = lambda do |filename, path|
      path =~ /app\/assets/ && !%w(.js .css .html).include?(File.extname(filename))
    end

    # Add the .html extension to the 'precompile' regex.
    config.assets.precompile = [LOOSE_APP_ASSETS, /(?:\/|\\|\A)application\.(css|js|html)$/]
  end
end
