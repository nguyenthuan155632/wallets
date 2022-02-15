class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_network, only: %i[show]

  def index
    @wallets = Wallet.includes(:tokens).where(user: current_user)
    @total_balance = Token.left_joins(:wallet).where('wallets.user_id = ?', current_user).sum(:balance).ceil(2)
  end

  def show
    @wallet = Wallet.find(params[:id])
    @tokens = @wallet.tokens.where(network: @network)
  end

  def destroy
    Wallet.find(params[:id]).destroy
    redirect_to wallets_path
  end

  private

  def set_network
    @network = Network.find_by(chain_id: params[:chain_id], user: current_user) || Network.binance_smart_chain(current_user)
  end
end
