class Network < ApplicationRecord
  belongs_to :user

  before_save :disallow_inactive_bsc

  scope :actived, -> { where(active: true) }

  def self.binance_smart_chain(user)
    find_or_create_by(network_name: 'Binance Smart Chain', chain_id: 56, user: user)
  end

  private

  def disallow_inactive_bsc
    return unless chain_id_was == 56

    self.chain_id = 56
    self.network_name = 'Binance Smart Chain'
    self.active = true
  end
end
