# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contented/version'

Gem::Specification.new do |gem|
  gem.name          = "contented"
  gem.version       = Contented::VERSION
  gem.authors       = ["Amay Yadav", "Eric Griffis", "Barnaby Alter"]
  gem.email         = ["amay@nyu.edu", "eric.griffis@nyu.edu", "barnaby.alter@nyu.edu"]
  gem.description   = %q{Content and test helpers for the NYU Libraries website}
  gem.summary       = %q{Content and test helpers for the NYU Libraries website}
  gem.homepage      = "https://github.com/NYULibraries/contented"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.licenses      = ['MIT']

  gem.required_ruby_version = '>= 2.4.0'
  gem.add_dependency 'sshkit', '>= 1.7.1'
  gem.add_dependency 'rake', '>= 10.0.0'
  gem.add_dependency 'faraday', '>= 0.9.0'
  gem.add_dependency 'i18n', '>= 0.7.0'
  gem.add_dependency 'swiftype', '~> 1.2.2'
  gem.add_dependency 'ox'
  gem.add_dependency 'liquid'
end
