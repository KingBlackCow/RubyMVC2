require 'mailgun-ruby'

class MymailerMailer < ApplicationMailer
  def simple_send(from_email, to_email, title, content)
    Rails.logger.debug from_email
    Rails.logger.debug to_email
    Rails.logger.debug title
    Rails.logger.debug content

    @hello = "Hello World"
    @content = content
    mail(from: from_email,
         to: to_email,
         subject: title,
         text: content)
  end
end
