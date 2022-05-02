# frozen_string_literal: true

class RefreshDailyJob < ApplicationJob
  def perform
    User.all.each do |user|
      # Have Chain
      Network.where(user: user).have_chain.actived.each do |network|
        Wallet.where(user: user).bep20.each do |wallet|
          wallet.write_token_number_cache(network)
          RefreshWallet.call(wallet: wallet, network: network)
        end
      end
      # ONTOLOGY
      network = Network.ontology(user)
      Wallet.where(user: user).ontology.each do |wallet|
        wallet.write_token_number_cache(network)
        RefreshWallet.call(wallet: wallet, network: network)
      end
    end
    Token.where(network: Network.have_chain, balance: 0).destroy_all
    Token.where(network: Network.have_chain, contract_name: Trash.select(:contract_name)).destroy_all

    data_changed = []
    Token.except_small_tokens.each do |token|
      number_of_tokens = Rails.cache.read(token.token_number_cache_key)
      data_changed <<
        if number_of_tokens
          token_data(token, old_number: number_of_tokens)
        else
          token_data(token)
        end
    end
    data_changed.reject! { |d| d.old_number == d.new_number }
    Rails.cache.delete_matched('*:NUMBER_OF_TOKENS')
    UserMailer.balance_changed(data_changed).deliver_now
  end

  private

  def token_data(token, old_number: nil)
    OpenStruct.new(
      token_id: token.id,
      wallet_id: token.wallet.id,
      user_id: token.user.id,
      old_number: old_number,
      new_number: token.number_of_tokens
    )
  end
end
