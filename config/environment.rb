# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Heroku ActionMailer config
# ActionMailer::Base.smtp_settings = {
#   :address        => 'smtp.sendgrid.net',
#   :port           => '587',
#   :authentication => :plain,
#   :user_name      => ENV['Kaz'],
#   :password       => ENV['8Qyg%Z7gm#Dg'],
#   :domain         => 'heroku.com',
#   :enable_starttls_auto => true
# 
ActionMailer::Base.smtp_settings = {
	:address => "smtp.gmail.com",
	:port => 587,
	:domain => 'heroku.com',  
	:authentication => :plain, 
	:enable_starttls_auto => true,
	:user_name => 'jon.lo.hs@gmail.com',
	:password => 'n1blheim'
}