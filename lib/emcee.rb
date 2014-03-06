require "emcee/version"

require "emcee/helpers/action_view"
require "emcee/helpers/sprockets_view"
require "emcee/helpers/sprockets_compressing"

require "emcee/railtie"

module ActionView
  module Helpers
    module AssetUrlHelper
      include Emcee::Helpers::ActionView::AssetUrlHelper

      # Modify ActionView to recognize html files and the '/elements' path.
      ASSET_EXTENSIONS.merge!({ html: '.html' })
      ASSET_PUBLIC_DIRECTORIES.merge!({ html: '/elements' })
    end

    module AssetTagHelper
      include Emcee::Helpers::ActionView::AssetTagHelper
    end
  end
end

module Sprockets
  module Compressing
    include Emcee::Helpers::Sprockets::Compressing
  end
end
