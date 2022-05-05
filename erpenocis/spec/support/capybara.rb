Capybara.register_driver :headless_selenium_chrome_in_container do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--allow-insecure-localhost')
  options.add_argument('--ignore-certificate-errors')
	Capybara::Selenium::Driver.new app,
	browser: :chrome,
	url: "http://selenium_chrome:4444/wd/hub",
	capabilities: [options]
end
Capybara.default_driver = :headless_selenium_chrome_in_container
Capybara.server_host = "0.0.0.0"
Capybara.server_port = 5028
Capybara.app_host = 'http://web_erpenocis:5028'