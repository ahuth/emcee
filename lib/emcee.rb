require "emcee/version"

require "emcee/helpers/action_view/asset_url_helper"
require "emcee/helpers/action_view/asset_tag_helper"
require "emcee/helpers/sprockets/view_helpers"
require "emcee/helpers/sprockets/compressing_helpers"

require "emcee/railtie"

module Sprockets
  module Compressing
    include Emcee::Helpers::Sprockets::Compressing
  end
end
