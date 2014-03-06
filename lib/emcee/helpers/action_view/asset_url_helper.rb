module Emcee
  module Helpers
    module ActionView
      # This module defines methods that we will include into ActionView, to help
      # integrate our asset view helpers into Rails.
      #
      module AssetUrlHelper
        # Convenience method for html. Based on ActionView's standard
        # javascript_path method.
        #
        # For some reason, when monkey patching ActionView by including modules
        # instead of directly adding methods, we have to include this method here
        # AND in Emcee::Helpers::ActionView::AssetTagHelper.
        #
        # If, instead, we monkey patched ActionView directly, it would be enough
        # to define this method here.
        #
        def path_to_html(source, options = {})
          path_to_asset(source, { type: :html }.merge!(options))
        end
      end
    end
  end
end
