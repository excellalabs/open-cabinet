VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.ignore_host 'codeclimate.com'
  c.hook_into :webmock
end
