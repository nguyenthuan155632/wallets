# frozen_string_literal: true

class RefreshesController < ApplicationController
  before_action :authenticate_user!

  def index
    wallet = Wallet.bep20.find_by(id: params[:wallet_id], user: current_user)
    if wallet
      RefreshWallet.call(wallet: wallet, network: network_by_chain_id)
      CollectPricesFromTokens.call(user: current_user, network: network_by_chain_id)
    else
      networks_have_chain.each do |n|
        bep20_wallets.each { |w| RefreshWallet.call(wallet: w, network: n) }
        CollectPricesFromTokens.call(user: current_user, network: n)
      end
    end
    Token.where(contract_name: Trash.select(:contract_name)).destroy_all
  end

  def ontology
    wallet = Wallet.ontology.find_by(id: params[:wallet_id], user: current_user)
    if wallet
      RefreshWallet.call(wallet: wallet, network: ontology_network)
    else
      ontology_wallets.each { |w| RefreshWallet.call(wallet: w, network: ontology_network) }
    end
  end

  private

  def networks_have_chain
    Network.have_chain.where(user: current_user, chain_id: params[:chain_id]).actived
  end

  def bep20_wallets
    Wallet.bep20.where(user: current_user)
  end

  def ontology_wallets
    Wallet.ontology.where(user: current_user)
  end

  def network_by_chain_id
    @network_by_chain_id ||=
      Network.find_by(chain_id: params[:chain_id], user: current_user) || Network.binance_smart_chain(current_user)
  end

  def ontology_network
    @ontology_network ||= Network.ontology(current_user)
  end
end
