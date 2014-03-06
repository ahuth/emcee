module Emcee
  module Helpers
    module ActionView
      module AssetUrlHelper
        # Convenience method for html based on javascript_path.
        def path_to_html(source, options = {})
          path_to_asset(source, { type: :html }.merge!(options))
        end
      end
    end
  end
end
