# frozen_string_literal: true

class ImportController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    network = params[:address_type] == 'ontology' ? ontology_network : binance_network
    ImportWallet.call(params[:wallet_string], network, current_user)
    CollectPricesFromTokens.call(user: current_user, network: binance_network) if network.chain_id.positive?
    redirect_to wallets_path
  end

  private

  def binance_network
    Network.binance_smart_chain(current_user)
  end

  def ontology_network
    Network.ontology(current_user)
  end
end
