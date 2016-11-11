# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-magento2"
  gem.version       = "0.1.0"
  gem.authors       = "Coen Meerbeek"
  gem.email         = "cmeerbeek@gmail.com"
  gem.description   = %q{Input plugin for Magento2.}
  gem.homepage      = "https://github.com/cmeerbeek/fluent-plugin-magento2"
  gem.summary       = %q{Retrieve Magento2 data via the REST API.}
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "fluentd", [">= 0.10.58", "< 2"]
  gem.add_dependency "rest-client", '~> 2.0', '>= 2.0.0'
  gem.add_dependency "oauth", '~> 0.5.1'
  gem.add_dependency "json", '~> 2.0', '>= 2.0.2'
  gem.add_development_dependency "rake", "~> 0.9", ">= 0.9.2"
  gem.add_development_dependency "test-unit", "~> 3.1", ">= 3.1.0"
  gem.license = 'MIT'
end
