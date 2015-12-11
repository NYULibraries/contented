require 'figs'
require 'json'
require 'faraday'
Figs.load()

module Contented
  autoload :GatherContent, 'contented/gather_content'

  require 'contented/version'
end
