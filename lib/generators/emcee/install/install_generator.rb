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
        case
          when erb?
            insert_html_import("<%= html_import_tag \"application\", \"data-turbolinks-track\" => true %>\n  ", before: "<%= csrf_meta_tags %>")
          when haml?
            insert_html_import("= html_import_tag \"application\", \"data-turbolinks-track\" => true\n  ", before: "= csrf_meta_tags")
          when slim?
            insert_html_import("= html_import_tag \"application\", \"data-turbolinks-track\" => true\n  ", before: "= csrf_meta_tags")
        end
      end

      def copy_bowerrc
        copy_file "template.bowerrc", ".bowerrc"
      end

      private

      def insert_html_import(content, options={})
        insert_into_file(layout_file, content, options)
      end

      def erb?
        layout_file.match(/\.erb/)
      end

      def haml?
        layout_file.match(/\.haml/)
      end

      def slim?
        layout_file.match(/\.slim/)
      end

      def layout_file
        @layout_file ||= begin
                           file = Pathname(Dir[Rails.root.join("app","views","layouts","application*")].first)
                           file.relative_path_from(Rails.root).to_s
                         end
      end

    end
  end
end
