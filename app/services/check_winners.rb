# frozen_string_literal: true

class CheckWinners < Patterns::Service
  def initialize(data, user)
    @data = data
    @user = user
    @winners = []
  end

  def call
    winner_list.each do |wn|
      winner_address = wn.downcase.strip
      Wallet.where(user: user).each do |wallet|
        wallet_address = wallet.address.downcase.strip

        if winner_address.match?(/\.|\*/)
          s, e = winner_address.split(/[*.]+/)
          @winners << wallet.id if wallet_address.include?(s) && wallet_address.include?(e)
        end
        # Winner address is full address
        @winners << wallet.id if wallet_address == winner_address
      end
    end
    @winners
  end

  private

  attr_reader :data, :user

  def winner_list
    data.split("\r\n").compact.uniq
  end
end
