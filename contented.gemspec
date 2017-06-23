# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contented/version'

Gem::Specification.new do |gem|
  gem.name          = "contented"
  gem.version       = Contented::VERSION
  gem.authors       = ["Amay Yadav"]
  gem.email         = ["amay@nyu.edu"]
  gem.description   = %q{Contented converts multiple data streams to yaml for siteleaf}
  gem.summary       = %q{Contented - Usable YAML from various data sources}
  gem.homepage      = "https://github.com/NYULibraries/contented"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.licenses      = ['MIT']

  gem.required_ruby_version = '>= 2.2.5'
  gem.add_dependency 'sshkit', '>= 1.7.1'
  gem.add_dependency 'rake', '>= 10.0.0'
  gem.add_dependency 'faraday', '>= 0.9.0'
  gem.add_dependency 'i18n', '>= 0.7.0'
  gem.add_dependency 'swiftype', '~> 1.2.2'
  gem.add_dependency 'cucumber', '>= 2.3.3'
  gem.add_dependency 'rspec', '>= 3.3'
  gem.add_dependency 'selenium-webdriver', '>= 2.53.4'
  gem.add_dependency 'phantomjs', '>= 2.1.1'
  gem.add_dependency 'poltergeist', '>= 1.12.0'
  gem.add_development_dependency 'pry'
end
