class RefreshesController < ApplicationController
  before_action :authenticate_user!

  def index
    wallet = Wallet.find_by(id: params[:wallet_id], user: current_user)
    if wallet
      network = Network.find_by(chain_id: params[:chain_id], user: current_user) || Network.binance_smart_chain(current_user)
      requester = RequestWalletApi.call(address: wallet.address, chain_id: network.chain_id).result
      requester.items.each do |item|
        token = Token.find_or_create_by(
          wallet: wallet,
          network: network,
          contract_name: item.contract_name,
          contract_ticker_symbol: item.contract_ticker_symbol,
          contract_address: item.contract_address
        )
        token.update(logo_url: item.logo_url)
        token.update(balance: item.quote)
      end
    else
      Network.where(user: current_user, chain_id: params[:chain_id]).each do |n|
        Wallet.distinct
              .left_joins(tokens: :network)
              .where('networks.chain_id = ?', n.chain_id)
              .where(user: current_user).each do |w|
          requester = RequestWalletApi.call(address: w.address, chain_id: n.chain_id).result
          requester.items.each do |item|
            token = Token.find_or_create_by(
              wallet: w,
              network: n,
              contract_name: item.contract_name,
              contract_ticker_symbol: item.contract_ticker_symbol,
              contract_address: item.contract_address
            )
            token.update(logo_url: item.logo_url)
            token.update(balance: item.quote)
          end
        end
      end
    end
  end
end
