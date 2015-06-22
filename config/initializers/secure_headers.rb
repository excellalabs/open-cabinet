::SecureHeaders::Configuration.configure do |config|
  config.hsts = { :max_age => 20.years.to_i, :include_subdomains => true }
  config.x_frame_options = 'DENY'
  config.x_content_type_options = 'nosniff'
  config.x_xss_protection = { value: 1, mode: 'block' }
  config.x_download_options = 'noopen'
  config.x_permitted_cross_domain_policies = { value: 'none' }
  config.csp = false
end
