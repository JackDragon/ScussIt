# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Heroku ActionMailer config
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['Kaz'],
  :password       => ENV['8Qyg%Z7gm#Dg'],
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}