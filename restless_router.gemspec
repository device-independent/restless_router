# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'restless_router/version'

Gem::Specification.new do |spec|
  spec.name          = "restless_router"
  spec.version       = RestlessRouter::VERSION
  spec.authors       = ["Nate Klaiber"]
  spec.email         = ["nate@theklaibers.com"]
  spec.summary       = %q{Enable simple route definitions for external resources.}
  spec.description   = %q{Many web services lack hypermedia or consistent routing. This gives a single place to house routes using URI Templates instead of building URLs throughout the client.}
  spec.homepage      = "https://github.com/nateklaiber/restless_router"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency("bundler", "~> 1.5")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec")
  spec.add_development_dependency("yard")

  spec.add_dependency("addressable")
end
