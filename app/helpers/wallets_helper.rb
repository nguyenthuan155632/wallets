# frozen_string_literal: true

module WalletsHelper
  def network_options
    Network.have_chain
           .actived
           .where(user: current_user)
           .pluck(:network_name, :chain_id)
  end

  def current_chain
    params[:chain_id].presence || Network::BSC_CHAIN_ID
  end

  def wallet_balance(wallet)
    Token
      .left_joins(:network)
      .where(wallets: wallet, networks: { chain_id: current_chain })
      .sum(&:balance)
      .ceil(2)
  end
end
