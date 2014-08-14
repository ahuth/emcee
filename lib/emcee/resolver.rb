module Emcee
  # Resolver is responsible for interfacing with Sprockets.
  class Resolver
    def initialize(context)
      @context = context
      @directory = File.dirname(context.pathname)
    end

    # Declare a file as a dependency to Sprockets. The dependency will be
    # included in the application's html bundle.
    def require_asset(path)
      @context.require_asset(path)
    end

    # Return the contents of a file. Does any required processing, such as SCSS
    # or CoffeeScript.
    def evaluate(path)
      @context.evaluate(path)
    end

    # Indicate if an asset should be inlined or not. References to files at an
    # external web address, for example, should not be inlined.
    def should_inline?(path)
      path !~ /\A\/\//
    end

    def absolute_path(path)
      File.absolute_path(path, @directory)
    end
  end
end
