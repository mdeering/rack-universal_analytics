# Encoding: utf-8
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into             :webmock
  # config.debug_logger = File.open(ARGV.first, 'w')
end
