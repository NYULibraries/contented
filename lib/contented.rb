require 'json'
require 'faraday'
require 'gather_content'
require 'open-uri'
require 'i18n'
require 'swiftype'

module Contented
  # Load all files in lib/contented into the Contented module
  Dir[File.dirname(__FILE__) + "/contented/**/*.rb"].each {|f| require f }

  if I18n.available_locales.empty?
    I18n.available_locales = [:en]
  end
end
