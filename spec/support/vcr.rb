require 'vcr'

VCR.configure do |c|
  c.default_cassette_options = { record: :once, allow_playback_repeats: true }
  # c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
end
