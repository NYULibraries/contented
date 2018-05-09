# configure poltergeist with js error throwing/logging off and with timeouts
# set for our tests
def configure_poltergeist
  # DEFAULT: headless tests with poltergeist/PhantomJS
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(
      app,
      phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],
      window_size: [1280, 1024],
      timeout: (ENV['TIMEOUT'] || 30).to_i,
      js_errors: false,
      phantomjs_logger: StringIO.new,
      url_blacklist: ["https://libraryh3lp.com", "https://js-agent.newrelic.com"]
    )
  end
end

case ENV['DRIVER']
# if driver not set, default to poltergeist
when nil
  configure_poltergeist
  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist
  Capybara.current_driver = :poltergeist
  Capybara.default_max_wait_time = (ENV['MAX_WAIT'] || 8).to_i
# otherwise, run driver as a browser via selenium
else
  driver = ENV['DRIVER'].to_sym
  Capybara.default_driver = driver
  Capybara.javascript_driver = driver
  Capybara.current_driver = driver

  Before do |scenario|
    Capybara.page.driver.browser.manage.window.resize_to(1024, 800)
  end
end
