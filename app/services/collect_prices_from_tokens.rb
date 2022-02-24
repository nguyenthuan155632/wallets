class CollectPricesFromTokens < Patterns::Service
  def initialize(user:, network:)
    @user = user
    @network = network
  end

  def call
    Token.joins(:wallet).where('wallets.user_id = ? AND network_id = ?', user.id, network.id).group_by(&:contract_name).each do |_, tokens|
      token = tokens.first
      price = Price.find_by(contract_name: token.contract_name)
      if price
        price.update(
          quote_rate: token.quote_rate,
          quote_rate_24h: token.quote_rate_24h,
          contract_ticker_symbol: token.contract_ticker_symbol
        )
      else
        Price.create(
          contract_name: token.contract_name,
          contract_ticker_symbol: token.contract_ticker_symbol,
          quote_rate: token.quote_rate,
          quote_rate_24h: token.quote_rate_24h
        )
      end
    end
  end

  private

  attr_reader :user, :network
end
