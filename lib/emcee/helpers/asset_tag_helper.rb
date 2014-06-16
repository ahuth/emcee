module ActionView
  module Helpers
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
