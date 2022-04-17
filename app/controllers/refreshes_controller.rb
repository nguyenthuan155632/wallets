class RefreshesController < ApplicationController
  before_action :authenticate_user!

  def index
    wallet = Wallet.find_by(id: params[:wallet_id], user: current_user)
    if wallet
      network = Network.find_by(chain_id: params[:chain_id], user: current_user) || Network.binance_smart_chain(current_user)
      requester = RequestWalletApi.call(address: wallet.address, chain_id: network.chain_id).result
      requester.items.each do |item|
        next unless item.contract_name
        # next if item.quote.zero?

        token = Token.find_or_create_by(
          wallet: wallet,
          network: network,
          contract_name: item.contract_name,
          contract_ticker_symbol: item.contract_ticker_symbol,
          contract_address: item.contract_address,
        )
        token.update(
          logo_url: item.logo_url,
          balance: item.quote,
          quote_rate: item.quote_rate,
          quote_rate_24h: item.quote_rate_24h
        )
      end
      CollectPricesFromTokens.call(user: current_user, network: network)
    else
      Network.where(user: current_user, chain_id: params[:chain_id]).each do |n|
        Wallet.where(user: current_user).each do |w|
          requester = RequestWalletApi.call(address: w.address, chain_id: n.chain_id).result
          requester.items.each do |item|
            next unless item.contract_name
            # next if item.quote.zero?

            token = Token.find_or_create_by(
              wallet: w,
              network: n,
              contract_name: item.contract_name,
              contract_ticker_symbol: item.contract_ticker_symbol,
              contract_address: item.contract_address
            )
            token.update(
              logo_url: item.logo_url,
              balance: item.quote,
              quote_rate: item.quote_rate,
              quote_rate_24h: item.quote_rate_24h
            )
          end
        end
        CollectPricesFromTokens.call(user: current_user, network: n)
      end
    end
  end
end
