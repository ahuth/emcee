require "emcee/version"

require "emcee/helpers/action_view/asset_url_helper"
require "emcee/helpers/action_view/asset_tag_helper"
require "emcee/helpers/sprockets/view_helpers"
require "emcee/helpers/sprockets/compressing_helpers"

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
  module Rails
    module Helper
      include Emcee::Helpers::Sprockets::View
    end
  end

  module Compressing
    include Emcee::Helpers::Sprockets::Compressing
  end
end
