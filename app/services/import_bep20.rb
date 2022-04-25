class ImportBep20 < Patterns::Service
  def initialize(data, network, user)
    @addresses = data.split("\r\n").compact.uniq
    @network = network
    @user = user
  end
  
  def call
    addresses.each do |address|
      next if address.blank?
      wallet = Wallet.find_by('LOWER(wallets.address) = ? AND wallets.user_id = ?', address.downcase, user.id)
      next if wallet

      wallet = Wallet.create(address: address.strip, user: user)
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
  end

  private

  attr_reader :addresses, :network, :user
end
  