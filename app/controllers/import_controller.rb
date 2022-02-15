class ImportController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    addresses = params[:wallet_string].split("\r\n").compact.uniq
    addresses.each do |address|
      requester = RequestWalletApi.call(address: address).result
      wallet = Wallet.find_or_create_by(address: requester.address, user: current_user)
      requester.items.each do |item|
        token = Token.find_or_create_by(
          wallet: wallet,
          network: Network.binance_smart_chain(current_user),
          contract_name: item.contract_name,
          contract_ticker_symbol: item.contract_ticker_symbol,
          contract_address: item.contract_address
        )
        token.update(logo_url: item.logo_url)
        token.update(balance: item.quote)
      end
    end
    redirect_to wallets_path
  end
end
