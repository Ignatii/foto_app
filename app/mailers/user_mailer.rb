class UserMailer < ApplicationMailer
  def send_email(user)
    @user = user
    @greeting = 'Hi'
    mail to: user.email, subject: 'Your image is shitty!'
  end
end
