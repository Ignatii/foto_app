# default mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'ignatiy.anatolich@mail.ru'
  layout 'mailer'
end
