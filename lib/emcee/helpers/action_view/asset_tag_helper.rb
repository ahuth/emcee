module Emcee
  module Helpers
    module ActionView
      # This module defines our view helpers that we will include into ActionView.
      #
      module AssetTagHelper
        # Not sure why we have to define path_to_html here, which is already defined
        # in Emcee::Helpers::ActionView::AssetUrlHelper.
        #
        # If we directly monkey patched ActionView, we would not have to include
        # this here. But monkey patching through an include somehow requires this
        # to be defined in this module.
        #
        def path_to_html(source, options = {})
          path_to_asset(source, { type: :html }.merge!(options))
        end

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
end
