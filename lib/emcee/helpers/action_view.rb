module ActionView
  module Helpers
    module AssetUrlHelper
      # Modify ActionView to recognize html files and the '/elements' path.
      ASSET_EXTENSIONS.merge!({ html: '.html' })
      ASSET_PUBLIC_DIRECTORIES.merge!({ html: '/elements' })

      # Convenience method for html based on javascript_path.
      def html_path(source, options = {})
        path_to_asset(source, { type: :html }.merge!(options))
      end
      alias_method :path_to_html, :html_path
    end

    module AssetTagHelper
      # Custom view helper used to create an html import. Will search the asset
      # directories for the sources.
      #
      #   html_import_tag("navigation")
      #
      def html_import_tag(*sources)
        options = sources.extract_options!.stringify_keys
        path_options = options.extract!('protocol').symbolize_keys

        sources.uniq.map { |source|
          tag_options = {
            "rel" => "import",
            "href" => path_to_html(source, path_options)
          }.merge!(options)
          tag(:link, tag_options)
        }.join("\n").html_safe
      end
    end
  end
end
