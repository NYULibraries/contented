require File.expand_path('../../lib/loaders/base.rb', __FILE__)
require File.expand_path('../../lib/loaders/empty_theme.rb', __FILE__)
require File.expand_path('../../lib/loaders/utilities/google_sheet.rb', __FILE__)
require File.expand_path('../../lib/loaders/helpers/department.rb', __FILE__)
require File.expand_path('../../lib/convert/convert.rb', __FILE__)
require File.expand_path('../../lib/convert/convert.rb', __FILE__)
Dir['../../lib/helpers/*.rb'].each { |file| require file }
require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.default_cassette_options = { record: :new_episodes, match_requests_on: [:path] }
  config.cassette_library_dir     = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('KEY') { ENV['API_KEY'] } unless ENV['API_KEY'].nil?
  config.filter_sensitive_data('SECRET') { ENV['API_SECRET'] } unless ENV['API_SECRET'].nil?
  config.filter_sensitive_data('ID') { ENV['SITELEAF_ID'] } unless ENV['SITELEAF_ID'].nil?
  config.configure_rspec_metadata!
  config.debug_logger = File.open('vcr_errors', 'w')
end
