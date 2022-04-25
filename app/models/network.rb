class Network < ApplicationRecord
  belongs_to :user

  before_save :disallow_inactive_bsc

  scope :actived, -> { where(active: true) }
  scope :have_chain, -> { where.not(chain_id: -1) }

  def self.binance_smart_chain(user)
    find_or_create_by(network_name: 'Binance Smart Chain', chain_id: 56, user: user)
  end

  def self.ontology(user)
    find_or_create_by(network_name: 'Ontology', chain_id: -1, user: user, scan_url: 'https://explorer.ont.io/address')
  end

  private

  def disallow_inactive_bsc
    return unless chain_id_was == 56

    self.chain_id = 56
    self.network_name = 'Binance Smart Chain'
    self.active = true
  end
end
