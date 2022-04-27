# frozen_string_literal: true

require 'net/http'

# RequestWalletApi.call(address: '0x12d140A35361443977A2AFb38055e54d24908988').result
class RequestWalletApi < Patterns::Service
  def initialize(address:, chain_id: Network::BSC_CHAIN_ID)
    @address = address
    @chain_id = chain_id
    @endpoint = "https://api.covalenthq.com/v1/#{chain_id}/address/#{address}/balances_v2/"
  end

  def call
    uri = URI.parse(endpoint)
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
      req = Net::HTTP::Get.new(uri.request_uri)
      req.basic_auth API_KEY, ''
      http.request(req)
    end
    data = JSON.parse(res.body, object_class: OpenStruct).data
    return if data.nil?

    blacklist = Trash.pluck(:contract_name)
    whitelist = data.items.map(&:contract_name) - blacklist

    OpenStruct.new(
      address: data.address,
      quote_currency: data.quote_currency,
      chain_id: data.chain_id,
      items: data.items.select { |i| i.contract_name.in?(whitelist) }
    )
  end

  private

  API_KEY = 'ckey_5867a5a8e38b486d9b7f7214442'

  attr_reader :address, :chain_id, :endpoint
end
