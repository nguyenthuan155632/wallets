class ImportController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    addresses = params[:wallet_string].split("\r\n").compact.uniq
    network = Network.binance_smart_chain(current_user)
    addresses.each do |address|
      next if address.blank?
      wallet = Wallet.find_by('LOWER(wallets.address) = ? AND wallets.user_id = ?', address.downcase, current_user.id)
      next if wallet

      wallet = Wallet.create(address: address.strip, user: current_user)
      requester = RequestWalletApi.call(address: wallet.address).result
      next if requester.nil?

      requester.items.each do |item|
        next unless item.contract_name

        token = Token.find_or_create_by(
          wallet: wallet,
          network: network,
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
    CollectPricesFromTokens.call(user: current_user, network: network)
    redirect_to wallets_path
  end
end
