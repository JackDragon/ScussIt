class UserMailer < ActionMailer::Base
  default from: "app30988389@heroku.com"

  def welcome_message(user)
    @user = user
    mail(
      :to => user.email, 
      :subject => "Welcome to Scuss"
    )
  end
end
