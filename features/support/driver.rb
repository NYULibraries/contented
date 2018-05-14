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
# run chrome headless when specified
when "chrome"
  Capybara.register_driver :chrome_headless do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: {
        args: %w[ no-sandbox headless disable-gpu window-size=1280,1024]
      }
    )

    Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
  end

  Capybara.javascript_driver = :chrome_headless
  Capybara.default_driver = :chrome_headless
  Capybara.current_driver = :chrome_headless
# run firefox headless when specified
# when "firefox"
#   Capybara.register_driver :firefox_headless do |app|
#     capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(
#       firefoxOptions: {
#         args: %w[ no-sandbox headless disable-gpu window-size=1280,1024]
#       }
#     )
#
#     Capybara::Selenium::Driver.new(app, browser: :firefox, desired_capabilities: capabilities)
#   end
#
#   Capybara.javascript_driver = :firefox_headless
#   Capybara.default_driver = :firefox_headless
#   Capybara.current_driver = :firefox_headless
else
  raise "Invalid driver '#{ENV['DRIVER']}'"
end
