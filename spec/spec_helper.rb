$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"
Dir['#{File.dirname(__FILE__)}/support/**/*.rb'].each { |file| require file }
require 'coveralls'
Coveralls.wear!

require 'contented'
