module ActionView
  module Helpers
    module AssetUrlHelper
      # Modify ActionView to recognize html files and the '/elements' path.
      ASSET_EXTENSIONS.merge!({ html: '.html' })
      ASSET_PUBLIC_DIRECTORIES.merge!({ html: '/elements' })

      # Convenience method for html. Based on ActionView's standard
      # javascript_path method.
      def path_to_html(source, options = {})
        path_to_asset(source, { type: :html }.merge!(options))
      end
    end
  end
end
