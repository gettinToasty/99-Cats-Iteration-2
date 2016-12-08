class UserMailer < ApplicationMailer
  default from: 'everybody@appacademy.io'

  def welcome_mailer(user)
    @user = user
    @url  = 'http://99-cats.com/login'
    mail(to: user.username, subject: 'Welcome to 99 Cats')
  end
end
