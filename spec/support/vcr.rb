require 'vcr'

VCR.configure do |c|
  c.filter_sensitive_data('api-key') { ENV['GATHER_CONTENT_API_KEY'] }
  c.filter_sensitive_data('api-id') { ENV['GATHER_CONTENT_API_USERNAME'].gsub(/@/,'%40') }
  c.default_cassette_options = { record: :once, allow_playback_repeats: true }
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
end
