module Emcee
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Adds an html import tag into your layout, adds a manifest to assets/components/application.html, and adds a vendor/assets/components directory"

      def copy_application_manifest
        empty_directory "app/assets/components"
        copy_file "application.html", "app/assets/components/application.html"
      end

      def create_vendor_directory
        empty_directory "vendor/assets/components"
        create_file "vendor/assets/components/.keep"
      end

      def add_html_import_to_layout
        insert_into_file "app/views/layouts/application.html.erb", "<%= html_import_tag \"application\", \"data-turbolinks-track\" => true %>\n  ", before: "<%= csrf_meta_tags %>"
      end
    end
  end
end
