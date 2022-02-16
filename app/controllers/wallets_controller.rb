class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_network, only: %i[show]

  def index
    @wallets =
      Wallet.distinct
            .left_joins(tokens: :network).where('networks.chain_id = ?', params[:chain_id].presence || 56)
            .where(user: current_user)
    @total_balance =
      Token.left_joins(:wallet, :network)
           .where('wallets.user_id = ? AND wallets.id IN (?) AND networks.chain_id = ?', current_user.id, @wallets.ids, params[:chain_id].presence || 56)
           .sum(:balance)
           .ceil(2)
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
