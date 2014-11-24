# Jonathan Lo
# Gangbaolede Li
# Bryant Chang

require "selenium-webdriver"
# require 'spec_helper'
# require 'rails_helper'

# class AssertionError < RuntimeError
# end

# def assert &block
#     raise AssertionError unless yield
# end

driver = Selenium::WebDriver.for :firefox
driver.get "http://scuss.herokuapp.com"
# driver.get "http://localhost:3000"

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

# check presence in user list
user_name = wait.until {driver.find_element(:xpath, "//div[@id='userbox']//p[1]")}.text
if user_name != "qqq"
	abort("User not present")
end

# type a message
send_message = wait.until {driver.find_element(:id, "message_input")}
send_message.send_keys "Test Sentence, Please Ignore."

# submit a message
send_message.send_keys :return

# check message exists
sleep(5)
message = driver.find_element(:xpath, "//p[last()]").text
puts(message)
if !message.include?("Test Sentence, Please Ignore.")
	abort("Message not found")
end

# check emoticon
send_message.send_keys ":)"
send_message.send_keys :return
sleep(5)
message = driver.find_element(:xpath, "//p[last()]").text
driver.find_element(:xpath, "//img[@src='/assets/smile.png']")

# add topic
send_message.send_keys "Hello #World"
send_message.send_keys :return

# click topic button
topic_button = driver.find_element(:xpath, "//button[@class='btn btn-primary topics']")
topic_button.click
sleep(5)
# # check newly added topic
# newly_added_topic = wait.until {driver.find_element(:xpath, "//button[@data-bb-handler='World']")}
newly_added_topic = wait.until {driver.find_element(:xpath, "//button[text()='#World']")}
newly_added_topic.click

# Check follow button
follow_button = driver.find_element(:xpath, "//button[@class='btn btn-primary follow']")
follow_text = follow_button.text
follow_button.click
# assert {follow_text != follow_button.text}
sleep(5)

if (follow_text == follow_button.text)
	abort("Follow button check failed")
end

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

# search
search = wait.until {driver.find_element(:xpath, "//input[@id='query']")}
search.send_keys "blue"
search.send_keys :return

# Edit profile
dropdown = wait.until {driver.find_element(:xpath, "//a[@class='dropdown-toggle']")}
dropdown.click
driver.find_element(:xpath, "//a[@href='/users/edit']").click

# Logout
dropdown = wait.until {driver.find_element(:xpath, "//a[@class='dropdown-toggle']")}
dropdown.click
driver.find_element(:xpath, "//a[@href='/users/sign_out']").click

puts "All tests passed!"

driver.quit
