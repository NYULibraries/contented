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
  config.filter_sensitive_data('Not that stupid') { "#{ENV['SITELEAF_KEY']}:#{ENV['SITELEAF_SECRET']}" }
  config.configure_rspec_metadata!
end
