require "selenium-webdriver"
require "test/unit"

class AssertionError < RuntimeError
end

def assert &block
    raise AssertionError unless yield
end

driver = Selenium::WebDriver.for :firefox
driver.get "http://scuss.herokuapp.com"

# navigate to sign in page
element = driver.find_element(:xpath, "//a[@href='/users/sign_in']")
element.click

# wait
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

# fill in credentials
user_input = wait.until { driver.find_element(:id, "user_email") }
user_input.send_keys "q@q.q"
pass_input = driver.find_element(:id, "user_password")
pass_input.send_keys "qqqqqqqq"
pass_input.submit

# click on channel
first_channel = wait.until {driver.find_element(:xpath, "//img[1]")}
first_channel.click

# type a message
send_message = wait.until {driver.find_element(:id, "message_input")}
send_message.send_keys "Test Sentence, Please Ignore."

# submit a message
send_message.send_keys :return

# Check follow button
follow_button = driver.find_element(:xpath, "//button[2]")
follow_text = follow_button.text
follow_button.click
assert {follow_text != follow_button.text}
# if (follow_text != follow_button.text)
# 	p "True"
# end

# check favorites page
driver.find_element(:xpath, "//a[@href='/mychannels']").click

# browse
browse_page = wait.until {driver.find_element(:xpath, "//a[@href='/browse']")}
browse_page.click

# browse next
browse_next = wait.until {driver.find_element(:xpath, "//input[@value='Next']")}
browse_next.click

# browse prev.
browse_prev = wait.until {driver.find_element(:xpath, "//input[@value='Previous']")}
browse_prev.click

# Edit profile
dropdown = wait.until {driver.find_element(:xpath, "//a[@class='dropdown-toggle']")}
dropdown.click
driver.find_element(:xpath, "//a[@href='/users/edit']").click

# Logout
dropdown = wait.until {driver.find_element(:xpath, "//a[@class='dropdown-toggle']")}
dropdown.click
driver.find_element(:xpath, "//a[@href='/users/sign_out']").click

puts driver.title

# driver.quit
