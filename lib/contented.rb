require 'json'
require 'faraday'
require 'gather_content'

module Contented
  require 'contented/version'
  autoload :Decorators, 'contented/decorators'
  autoload :Conversions, 'contented/conversions'
  autoload :Department, 'contented/department'
  autoload :Departments, 'contented/departments'
end
