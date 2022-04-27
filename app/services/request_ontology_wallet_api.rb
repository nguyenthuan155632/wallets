# frozen_string_literal: true

require 'net/http'

# RequestOntologyWalletApi.call(address: 'AZ1JxnLVWpXGa5psEM9xHeBHeUzKZ4zsvd').result
class RequestOntologyWalletApi < Patterns::Service
  def initialize(address:)
    @address = address
    @endpoint = "https://explorer.ont.io/v2/addresses/#{address}/native/balances"
  end

  def call
    uri = URI.parse(endpoint)
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
      req = Net::HTTP::Get.new(uri.request_uri)
      http.request(req)
    end
    data = JSON.parse(res.body, object_class: OpenStruct).result
    return if data.nil?

    data.map do |item|
      OpenStruct.new(
        balance: item.balance.to_f,
        asset_name: MAPPING_ASSETS[item.asset_name],
        contract_hash: item.contract_hash
      )
    end
  end

  private

  MAPPING_ASSETS = {
    'ong' => 'ONG',
    'ont' => 'ONT',
    'waitboundong' => 'Claimable ONG',
    'unboundong' => 'Unbound ONG'
  }.freeze

  attr_reader :address, :endpoint
end
