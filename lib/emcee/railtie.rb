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

# Monkey patch Sprockets-rails so that loose html files are handled correctly.
# In the /assets/elements directory, loose html files should be compiled into
# application.html. They should not be carried over as single files.
#
# Not sure that modifying another gem's railtie is a good idea, but it works
# for now.
module Sprockets
  class Railtie
    # Horrible hack: remove this 'constant' so we can redefine it without ruby
    # complaining.
    remove_const(:LOOSE_APP_ASSETS) if defined?(LOOSE_APP_ASSETS)

    # Ugly hack #1: redefine this 'constant' to recognize html files. Is there
    # a way to extend instead of redefining?
    LOOSE_APP_ASSETS = lambda do |filename, path|
      path =~ /app\/assets/ && !%w(.js .css .html).include?(File.extname(filename))
    end

    # Ugly hack #2: same as above (#1). Is there a way to extend this instead
    # of redefining?
    config.assets.precompile = [LOOSE_APP_ASSETS, /(?:\/|\\|\A)application\.(css|js|html)$/]
  end
end
