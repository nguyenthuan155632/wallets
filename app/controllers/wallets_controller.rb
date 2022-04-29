# frozen_string_literal: true

class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_network, only: %i[show]

  def index
    chain_id = params[:chain_id].presence || Network::BSC_CHAIN_ID
    @wallets = bep20_wallets
    if params[:token]
      @wallets =
        @wallets.left_joins(tokens: :network)
                .where(networks: { chain_id: chain_id }, tokens: { contract_ticker_symbol: params[:token] })
    end
    if params[:not_show_small_token] == 'true'
      @wallets =
        @wallets.left_joins(tokens: :network)
                .where('networks.chain_id = ? AND tokens.balance > ?', chain_id, params[:amount])
    end
    @total_balance =
      Token.left_joins(:wallet, :network)
           .where(wallets: @wallets, networks: { chain_id: chain_id })
           .sum(:balance)
           .ceil(2)
  end

  def show
    @wallet = Wallet.find(params[:id])
    @tokens = @wallet.tokens.where(network: @network)
  end

  def ontologies
    @wallets = ontology_wallets
    @total_ong = Token.where(wallet: @wallets, contract_name: 'ONG').sum(:balance).ceil(2)
    @total_ont = Token.where(wallet: @wallets, contract_name: 'ONT').sum(:balance).ceil(2)
  end

  def ontology
    @wallet = Wallet.find(params[:id])
  end

  def destroy
    Wallet.find(params[:id]).destroy
    redirect_to wallets_path
  end

  def bulk_delete
    Wallet.where(user: current_user).bep20.destroy_all
    redirect_to wallets_path
  end

  private

  def set_network
    @network = Network.find_by(chain_id: params[:chain_id],
                               user: current_user) || Network.binance_smart_chain(current_user)
  end

  def bep20_wallets
    @bep20_wallets ||= Wallet.distinct.bep20.where(user: current_user).order(:id)
  end

  def ontology_wallets
    @ontology_wallets ||= Wallet.includes(:tokens).ontology.where(user: current_user).order(:id)
  end
end
