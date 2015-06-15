require File.expand_path('../../lib/loaders/base.rb', __FILE__)
require File.expand_path('../../lib/loaders/empty_theme.rb', __FILE__)
require File.expand_path('../../lib/loaders/utilities/google_sheet.rb', __FILE__)
require 'vcr'
require 'webmock'
require 'open-uri'
require 'siteleaf'
require 'json'
require 'hashie'

VCR.configure do |config|
  config.default_cassette_options = { record: :new_episodes, allow_playback_repeats: true }
  config.cassette_library_dir     = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('Not that stupid') { 'efb629faf35a68ec48ac8b4acf1d4ad7:7c604efc88c676ca9c23b2be5675698b' }
  config.configure_rspec_metadata!
end
