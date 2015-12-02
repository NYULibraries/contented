require 'figs'
Figs.load()
module GatherContent
  Dir[File.dirname(__FILE__) + '/**/*.rb'].each do |file|
    require_relative file
  end
end
