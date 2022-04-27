# frozen_string_literal: true

class RefreshDailyJob < ApplicationJob
  def perform
    User.all.each do |user|
      # Have Chain
      Network.where(user: user).have_chain.actived.each do |network|
        Wallet.where(user: user).bep20.each { |wallet| RefreshWallet.call(wallet: wallet, network: network) }
      end
      # ONTOLOGY
      Wallet.where(user: user).ontology.each do |wallet|
        RefreshWallet.call(wallet: wallet, network: Network.ontology(user))
      end
    end
    Token.where(network: Network.have_chain, balance: 0).destroy_all
    Token.where(network: Network.have_chain, contract_name: Trash.select(:contract_name)).destroy_all
  end
end
