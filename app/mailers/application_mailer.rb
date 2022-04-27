# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'wallet-guys@gmail.com'
  layout 'mailer'
end
