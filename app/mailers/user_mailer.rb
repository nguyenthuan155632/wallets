# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def balance_changed(data)
    data.group_by(&:user_id).each do |user_id, wallets|
      user = User.find_by(id: user_id)
      next unless user

      mail(
        to: user.email,
        template_path: 'user_mailer/balance_changed',
        subject: '[WALLET-GUYS] Your balance changed'
      ) do |format|
        format.html do
          render locals: { wallets: wallets.group_by(&:wallet_id) }
        end
      end
    end
  end
end
