class UserMailer < ApplicationMailer
  def balance_changed(before, after)
    after.each do |user_id, wallets|
      user = User.find_by(id: user_id)
      next unless user

      mail(to: user.email, template_path: 'user_mailer/balance_changed', subject: '[WALLET-GUYS] Your balance changed') do |format|
        format.html {
          render locals: { wallets: wallets, before: before, after: after, user: user }
        }
      end
    end
  end
end
