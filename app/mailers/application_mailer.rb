# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'nt.apple.it@gmail.com'
  layout 'mailer'
end
