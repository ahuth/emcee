$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "emcee/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "emcee"
  s.version     = Emcee::VERSION
  s.authors     = ["Andrew Huth"]
  s.email       = ["andrew@legion.io"]
  s.homepage    = "https://github.com/ahuth/emcee"
  s.summary     = "Add web components to the asset pipeline."
  s.description = "Add web components to the rails asset pipeline"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency "sqlite3"
end
