class Network < ApplicationRecord
  belongs_to :user

  def self.binance_smart_chain(user)
    find_or_create_by(network_name: 'Binance Smart Chain', chain_id: 56, user: user)
  end

end
