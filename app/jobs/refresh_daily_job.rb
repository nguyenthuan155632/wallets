class RefreshDailyJob < ApplicationJob
  def perform
    User.all.each do |user|
      Network.where(user: user).each do |n|
        Wallet.where(user: user).each do |w|
          requester = RequestWalletApi.call(address: w.address, chain_id: n.chain_id).result
          requester.items.each do |item|
            next unless item.contract_name
            next if item.quote.zero?
  
            token = Token.find_or_create_by(
              wallet: w,
              network: n,
              contract_name: item.contract_name,
              contract_ticker_symbol: item.contract_ticker_symbol,
              contract_address: item.contract_address
            )
            token.update(
              logo_url: item.logo_url,
              balance: item.quote,
              quote_rate: item.quote_rate,
              quote_rate_24h: item.quote_rate_24h
            )
          end
        end
        # CollectPricesFromTokens.call(user: user, network: n)
      end
    end
    Token.where(balance: 0).destroy_all
  end
end