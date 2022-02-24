class ImportController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    addresses = params[:wallet_string].split("\r\n").compact.uniq
    addresses.each do |address|
      wallet = Wallet.find_by('LOWER(wallets.address) = ? AND wallets.user_id = ?', address.downcase, current_user.id)
      next if wallet

      wallet = Wallet.create(address: address.strip, user: current_user)
      requester = RequestWalletApi.call(address: wallet.address).result
      requester.items.each do |item|
        next unless item.contract_name

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
