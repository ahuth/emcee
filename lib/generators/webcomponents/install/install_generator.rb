module Webcomponents
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Adds an html import tag into your layout, adds a manifest to assets/elements/application.html, and adds a vendor/assets/elements directory"

      def copy_application_manifest
        empty_directory "app/assets/elements"
        copy_file "application.html", "app/assets/elements/application.html"
      end

      def create_vendor_directory
        empty_directory "vendor/assets/elements"
        create_file "vendor/assets/elements/.keep"
      end

      def add_html_import_to_layout
        insert_into_file "app/views/layouts/application.html.erb", "<%= html_import_tag \"application\" %>\n\t\t", before: "<%= csrf_meta_tags %>"
      end
    end
  end
end
