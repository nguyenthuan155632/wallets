class ImportController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    if params[:address_type] == 'ontology'
      ImportOntology.call(params[:wallet_string], ontology_network, current_user)
    else
      ImportBep20.call(params[:wallet_string], binance_network, current_user)
    end
    CollectPricesFromTokens.call(user: current_user, network: binance_network)
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
