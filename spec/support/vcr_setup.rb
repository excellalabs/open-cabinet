VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.ignore_hosts 'codeclimate.com'
end
