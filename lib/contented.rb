require 'json'
require 'faraday'
require 'gather_content'

module Contented
  autoload :Decorators, 'contented/decorators'
  autoload :Conversions, 'contented/conversions'
  require 'contented/version'
  require 'contented/department'
  require 'contented/departments'
  require 'contented/conversions'
end
