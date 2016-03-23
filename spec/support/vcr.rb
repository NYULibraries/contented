require 'vcr'

VCR.configure do |c|
  c.filter_sensitive_data('api-key') { ENV['gather_content_api_key'] }
  c.filter_sensitive_data('api-id') { ENV['gather_content_api_username'].gsub(/@/,'%40') }
  c.default_cassette_options = { :record => :new_episodes, :allow_playback_repeats => true }
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
end
