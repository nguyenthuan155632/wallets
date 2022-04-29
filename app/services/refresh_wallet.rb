# frozen_string_literal: true

class RefreshWallet < Patterns::Service
  def initialize(wallet:, network:)
    @wallet = wallet
    @network = network
    @chain = wallet.address_type
  end

  def call
    refresh_bep20_chain if chain == 'bep20'
    refresh_ontology_chain if chain == 'ontology'
    wallet
  end

  private

  attr_reader :wallet, :network, :chain

  def items_from_requested_api
    case chain
    when 'bep20'
      RequestWalletApi.call(address: wallet.address, chain_id: network.chain_id).result&.items
    when 'ontology'
      RequestOntologyWalletApi.call(address: wallet.address).result
    end
  end

  def refresh_bep20_chain
    return unless items_from_requested_api

    items_from_requested_api.each do |item|
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
        quote_rate_24h: item.quote_rate_24h,
        number_of_tokens: item.balance
      )
      token.reload
      token.destroy if token.balance.zero?
    end
  end

  def refresh_ontology_chain
    return unless items_from_requested_api

    items_from_requested_api.each do |item|
      next unless item.asset_name

      token = Token.find_or_create_by(
        wallet: wallet,
        network: network,
        contract_name: item.asset_name,
        contract_ticker_symbol: item.asset_name,
        contract_address: item.contract_hash
      )
      token.update(balance: item.balance, number_of_tokens: item.balance.to_s)
    end
  end
end
