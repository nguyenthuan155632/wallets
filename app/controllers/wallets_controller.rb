class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_network, only: %i[show]

  def index
    @wallets = Wallet.distinct.bep20.where(user: current_user).order(:id)
    if params[:not_show_small_token] == 'true'
      @wallets =
        @wallets.left_joins(tokens: :network)
                .where('networks.chain_id = ? AND tokens.balance > ?', params[:chain_id].presence || 56, params[:amount])
    end
    @total_balance =
      Token.left_joins(:wallet, :network)
           .where('wallets.id IN (?) AND networks.chain_id = ?', @wallets.ids, params[:chain_id].presence || 56)
           .sum(:balance)
           .ceil(2)
  end

  def show
    @wallet = Wallet.find(params[:id])
    @tokens = @wallet.tokens.where(network: @network)
  end

  def ontologies
    @wallets = Wallet.includes(:tokens).ontology.where(user: current_user).order(:id)
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
    @network = Network.find_by(chain_id: params[:chain_id], user: current_user) || Network.binance_smart_chain(current_user)
  end
end
