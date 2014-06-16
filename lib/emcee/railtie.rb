require "emcee/html_processor"
require "emcee/html_compressor"

module Emcee
  class Railtie < Rails::Railtie
    initializer :add_html_processor do |app|
      app.assets.register_mime_type "text/html", ".html"
      app.assets.register_preprocessor "text/html", HtmlProcessor
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
