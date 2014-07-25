module Emcee
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Adds an html import tag into your layout, adds a manifest to assets/components/application.html, and adds a vendor/assets/components directory"

      class_option :layout, :type => :string, :desc => "The path of the layout file to inject the html import tag into"

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
            insert_html_import("<%= html_import_tag \"application\", \"data-turbolinks-track\" => true %>", before: "<%= csrf_meta_tags %>")
          when haml? || slim?
            insert_html_import("= html_import_tag \"application\", \"data-turbolinks-track\" => true", before: "= csrf_meta_tags")
        end
      end

      def copy_bowerrc
        copy_file "template.bowerrc", ".bowerrc"
      end

      private

      def insert_html_import(content, options={})
        # if this is a slim or haml file we need to match the indentation level
        if options[:before] && (line = layout_file.read.lines.detect {|l| l.include?(options[:before].to_s) })
          indentation = line.match(/^\s+/).to_s
          content = content + "\n#{indentation}"
        end

        insert_into_file(layout_file.to_s, content, options)
      end

      def erb?
        layout_file.extname.match(/\.erb/)
      end

      def haml?
        layout_file.extname.match(/\.haml/)
      end

      def slim?
        layout_file.extname.match(/\.slim/)
      end

      def layout_file
        file = Pathname(options["layout"] || Dir[Rails.root.join("app","views","layouts","application*")].first)
        file.relative? ? file : file.relative_path_from(Rails.root)
      end

    end
  end
end
