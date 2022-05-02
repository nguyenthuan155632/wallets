# frozen_string_literal: true

class Token < ApplicationRecord
  ONTOLOGY_CONTRACT_ADDRESS = %w[
    0100000000000000000000000000000000000000
    0200000000000000000000000000000000000000
  ].freeze

  belongs_to :wallet
  belongs_to :network

  scope :except_small_tokens, -> { where('tokens.balance >= ?', 1) }

  delegate :user, to: :wallet

  def cache_key
    "UID:#{user.id}_NETID:#{network.id}_WADDR:#{wallet.address}_SYMB:#{contract_ticker_symbol.downcase.gsub(/\s+/, '-')}"
  end

  def token_number_cache_key
    "#{cache_key}:NUMBER_OF_TOKENS"
  end
end
