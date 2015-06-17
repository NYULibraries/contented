require File.expand_path('../../lib/loaders/base.rb', __FILE__)
require File.expand_path('../../lib/loaders/empty_theme.rb', __FILE__)
require File.expand_path('../../lib/loaders/utilities/google_sheet.rb', __FILE__)
require File.expand_path('../../lib/loaders/helpers/department.rb', __FILE__)
require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.default_cassette_options = { record: :new_episodes, match_requests_on: [:path] }
  config.cassette_library_dir     = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('KEY') { ENV['SITELEAF_KEY'] } unless ENV['SITELEAF_KEY'].nil?
  config.filter_sensitive_data('SECRET') { ENV['SITELEAF_SECRET'] } unless ENV['SITELEAF_KEY'].nil?
  config.filter_sensitive_data('ID') { ENV['SITELEAF_ID'] } unless ENV['SITELEAF_ID'].nil?
  config.configure_rspec_metadata!
  config.debug_logger = File.open('vcr_errors', 'w')
end
