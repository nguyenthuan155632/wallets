class RefreshesController < ApplicationController
  before_action :authenticate_user!

  def index
    wallet = Wallet.bep20.find_by(id: params[:wallet_id], user: current_user)
    if wallet
      network = Network.find_by(chain_id: params[:chain_id], user: current_user) || Network.binance_smart_chain(current_user)
      requester = RequestWalletApi.call(address: wallet.address, chain_id: network.chain_id).result
      return if requester.nil?

      requester.items.each do |item|
        next unless item.contract_name

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
        token.reload
        token.destroy if token.balance.zero?
      end
      CollectPricesFromTokens.call(user: current_user, network: network)
    else
      Network.have_chain.where(user: current_user, chain_id: params[:chain_id]).actived.each do |n|
        Wallet.bep20.where(user: current_user).each do |w|
          requester = RequestWalletApi.call(address: w.address, chain_id: n.chain_id).result
          next if requester.nil?

          requester.items.each do |item|
            next unless item.contract_name

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
            token.reload
            token.destroy if token.balance.zero?
          end
        end
        CollectPricesFromTokens.call(user: current_user, network: n)
      end
    end
    Token.where(contract_name: Trash.pluck(:contract_name)).destroy_all
  end

  def ontology
    network = Network.ontology(current_user)
    wallet = Wallet.ontology.find_by(id: params[:wallet_id], user: current_user)
    if wallet
      items = RequestOntologyWalletApi.call(address: wallet.address).result
      return if items.nil?

      items.each do |item|
        next unless item.asset_name

        token = Token.find_or_create_by(
          wallet: wallet,
          network: network,
          contract_name: item.asset_name,
          contract_ticker_symbol: item.asset_name,
          contract_address: item.contract_hash
        )
        token.update(balance: item.balance)
      end
    else
      Wallet.ontology.where(user: current_user).each do |w|
        items = RequestOntologyWalletApi.call(address: w.address).result
        return if items.nil?

        items.each do |item|
          next unless item.asset_name
  
          token = Token.find_or_create_by(
            wallet: w,
            network: network,
            contract_name: item.asset_name,
            contract_ticker_symbol: item.asset_name,
            contract_address: item.contract_hash
          )
          token.update(balance: item.balance)
        end
      end
    end
  end
end
