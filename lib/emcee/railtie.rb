require "emcee/processors/html_processor"
require "emcee/compressors/html_compressor"

module Emcee
  class Railtie < Rails::Railtie
    initializer :add_html_processor do |app|
      app.assets.register_mime_type "text/html", ".html"
      app.assets.register_preprocessor "text/html", Processors::HtmlProcessor
    end

    initializer :add_html_compressor do |app|
      app.assets.html_compressor = Compressors::HtmlCompressor.new
    end
  end
end
