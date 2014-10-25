class UserMailer < ActionMailer::Base
  default from: "jon.lo.hs@gmail.com"

  def welcome_message(user)
    @user = user
    mail(
      # :from => "jon.lo.hs@gmail.com",
      :to => user.email, 
      :subject => "Welcome to Scuss"
    )
  end
end
