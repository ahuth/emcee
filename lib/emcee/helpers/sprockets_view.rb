module Sprockets
  module Rails
    module Helper
      def html_import_tag(*sources)
        options = sources.extract_options!.stringify_keys
        if options["debug"] != false && request_debug_assets?
          sources.map { |source|
            #check_errors_for(source)
            if asset = lookup_asset_for_path(source, type: :html)
              asset.to_a.map do |a|
                super(path_to_html(a.logical_path, debug: true), options)
              end
            else
              super(source, options)
            end
          }.flatten.uniq.join("\n").html_safe
        else
          sources.push(options)
          super(*sources)
        end
      end
    end
  end
end
