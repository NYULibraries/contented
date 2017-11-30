require 'json'
require 'faraday'
require 'gather_content'
require 'open-uri'
require 'i18n'
require 'swiftype'

module Contented
  require 'contented/version'
  autoload :Decorators, 'contented/decorators'
  autoload :Department, 'contented/department'
  autoload :Departments, 'contented/departments'
  autoload :SwiftypeSync, 'contented/swiftype_sync'
  autoload :Person, 'contented/person'
  autoload :SourceReaders, 'contented/source_readers'

  if I18n.available_locales.empty?
    I18n.available_locales = [:en]
  end
end
