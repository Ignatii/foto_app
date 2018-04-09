# spec/support/vcr_setup.rb
VCR.configure do |config|
  config.default_cassette_options = { record: :once, re_record_interval: 1.day }
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
