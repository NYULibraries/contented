# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contented/version'

Gem::Specification.new do |gem|
  gem.name          = 'contented'
  gem.version       = Contented::VERSION
  gem.authors       = ['Amay Yadav']
  gem.email         = ['amay@nyu.edu']
  gem.description   = 'Contented converts multiple data streams to yaml for siteleaf'
  gem.summary       = 'Contented - Usable YAML from various data sources'
  gem.homepage      = 'https://github.com/NYULibraries/contented'

  gem.files         = `git ls-files`.split($RS)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.licenses      = ['MIT']

  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency 'sshkit', '>= 1.7.1'
  gem.add_dependency 'rake', '>= 10.0.0'
  gem.add_dependency 'rest-client'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubycritic'
  gem.add_development_dependency 'coveralls'
end
