class RefreshDailyJob < ApplicationJob
  def perform
    User.all.each do |user|
      Network.where(user: user).actived.each do |n|
        Wallet.where(user: user).each do |w|
          requester = RequestWalletApi.call(address: w.address, chain_id: n.chain_id).result
          next if requester.nil?

          requester.items.each do |item|
            next unless item.contract_name
  
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
            token.reload
            token.destroy if token.balance.zero?
          end
        end
      end
    end
    Token.where(balance: 0).destroy_all
    Token.where(contract_name: Trash.pluck(:contract_name)).destroy_all
  end
end
