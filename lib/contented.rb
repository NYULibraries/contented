require 'json'
require 'faraday'
require 'gather_content'
require 'RestClient'

module Contented
  require 'contented/version'
  autoload :Decorators, 'contented/decorators'
  autoload :Conversions, 'contented/conversions'
  autoload :Helpers, 'contented/helpers'
  autoload :Department, 'contented/department'
  autoload :Departments, 'contented/departments'
end
