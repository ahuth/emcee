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
      # Return a file's contents as text. This is split out as a method so that
      # we can test the other methods in this module without actually reading from
      # the filesystem.
      def read_file(path)
        File.read(path)
      end
    end
  end
end
