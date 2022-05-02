# frozen_string_literal: true

class Wallet < ApplicationRecord
  has_many :tokens, dependent: :destroy
  belongs_to :user

  enum address_type: {
    bep20: 'BEP20',
    ontology: 'Ontology'
  }

  validates :address, uniqueness: { scope: :user_id, case_sensitive: false, message: 'should be inserted once!' }

  def balance
    tokens.sum(:balance)
  end

  def write_token_number_cache(network)
    tokens.where(network: network).each do |token|
      Rails.cache.fetch(token.token_number_cache_key) { token.number_of_tokens }
    end
  end
end
