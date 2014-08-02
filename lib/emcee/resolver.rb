module Emcee
  # Resolver is responsible for interfacing with Sprockets.
  class Resolver
    def initialize(context)
      @context = context
      @directory = File.dirname(context.pathname)
    end

    def require_asset(path)
      @context.require_asset(path)
    end

    def evaluate(path)
      @context.evaluate(path)
    end

    def should_inline?(path)
      path !~ /\A\/\//
    end

    def absolute_path(path)
      File.absolute_path(path, @directory)
    end
  end
end
