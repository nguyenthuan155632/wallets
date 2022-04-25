class ImportOntology < Patterns::Service
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

      wallet = Wallet.create(address: address.strip, address_type: 'ontology', user: user)
      items = RequestOntologyWalletApi.call(address: wallet.address).result
      next if items.nil?

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
    end
  end

  private

  attr_reader :addresses, :network, :user
end
  