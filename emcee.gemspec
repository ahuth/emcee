$:.push File.expand_path("../lib", __FILE__)

require "emcee/version"

Gem::Specification.new do |s|
  s.name        = "emcee"
  s.version     = Emcee::VERSION
  s.authors     = ["Andrew Huth"]
  s.email       = ["andrew@huth.me"]
  s.homepage    = "https://github.com/ahuth/emcee"
  s.summary     = "Add web components to the Rails asset pipeline."
  s.description = "Add web components to the Rails asset pipeline"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "nokogiri", "~> 1.0"
  s.add_dependency "nokogumbo", "~> 1.1"
  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency "coffee-rails", "~> 4.0"
  s.add_development_dependency "sass", "~> 3.0"
  s.add_development_dependency "sqlite3", "~> 1.3"
end
