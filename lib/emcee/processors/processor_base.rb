require "emcee/processors/processor_imports"
require "emcee/processors/processor_scripts"
require "emcee/processors/processor_stylesheets"

module Emcee
  module Processors
    # This module has method definition that we will include into HtmlProcessor.
    #
    # We seperate these out to make them easier to test. Testing a class that inherits
    # from Sprockets::DirectiveProcessor (which our HtmlProcessor does) is not
    # straightforward.
    #
    module Includes
      # Match the path from the href attribute of an html import or stylesheet
      # include tag. Captures the actual path.
      #
      #   href="/assets/example.css"
      #
      HREF_PATH_PATTERN = /href=["'](?<path>[\w\.\/-]+)["']/

      # Match the source path from a script tag. Captures the actual path.
      #
      #   src="/assets/example.js"
      #
      SRC_PATH_PATTERN = /src=["'](?<path>[\w\.\/-]+)["']/

      # Match the indentation whitespace of a line
      #
      INDENT_PATTERN = /^(?<indent>\s*)/

      # Return a file's contents as text. This is split out as a method so that
      # we can test the other methods in this module without actually reading from
      # the filesystem.
      def read_file(path)
        File.read(path)
      end
    end
  end
end
