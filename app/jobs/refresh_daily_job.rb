# frozen_string_literal: true

# Need to be refactored
class RefreshDailyJob < ApplicationJob
  def perform
    before = {}
    after = {}
    User.all.each do |user|
      before[user.id] = {}
      after[user.id] = {}
      # Have Chain
      Network.where(user: user).have_chain.actived.each do |network|
        Wallet.where(user: user).bep20.each do |wallet|
          before[user.id][wallet.id] = {}
          after[user.id][wallet.id] = {}
          # Check Balance before refreshing
          wallet.tokens.each do |token|
            before[user.id][wallet.id][token.id] = token.number_of_tokens
          end
          RefreshWallet.call(wallet: wallet, network: network)
          # Check Balance after refreshing
          wallet.tokens.reload.each do |token|
            after[user.id][wallet.id][token.id] = token.number_of_tokens
          end
        end
      end
      # ONTOLOGY
      Wallet.where(user: user).ontology.each do |wallet|
        before[user.id][wallet.id] = {}
        after[user.id][wallet.id] = {}
        # Check Balance before refreshing
        wallet.tokens.each do |token|
          before[user.id][wallet.id][token.id] = token.number_of_tokens
        end
        RefreshWallet.call(wallet: wallet, network: Network.ontology(user))
        # Check Balance after refreshing
        wallet.tokens.reload.each do |token|
          after[user.id][wallet.id][token.id] = token.number_of_tokens
        end
      end
    end
    Token.where(network: Network.have_chain, balance: 0).destroy_all
    Token.where(network: Network.have_chain, contract_name: Trash.select(:contract_name)).destroy_all

    after.each do |user_id, wallets|
      wallets.each do |wallet_id, tokens|
        tokens.each do |token_id, number_of_tokens|
          after[user_id][wallet_id].delete(token_id) if after[user_id][wallet_id][token_id] == before[user_id][wallet_id][token_id]
        end
        after[user_id].delete(wallet_id) if after[user_id][wallet_id].blank?
      end
      after.delete(user_id) if after[user_id].blank?
    end
    UserMailer.balance_changed(before, after).deliver_now
  end
end
