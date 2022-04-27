# frozen_string_literal: true

class ImportWallet < Patterns::Service
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

      wallet = Wallet.create(
        address: address.strip,
        address_type: network.ontology? ? 'ontology' : 'bep20',
        user: user
      )
      RefreshWallet.call(wallet: wallet, network: network)
    end
  end

  private

  attr_reader :addresses, :network, :user
end
