require "webcomponents/processors/html_processor"
require "webcomponents/compressors/html_compressor"

module Webcomponents
  class Railtie < Rails::Railtie
    initializer :add_html_processor do |app|
      app.config.assets.register_mime_type "text/html", ".html"
      app.config.assets.register_preprocessor "text/html", Processors::HtmlProcessor
    end

    initializer :add_html_compressor do |app|
      app.config.assets.html_compressor = Compressors::HtmlCompressor.new
    end
  end
end
