# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'app249698135@heroku.com'
  layout 'mailer'
end
