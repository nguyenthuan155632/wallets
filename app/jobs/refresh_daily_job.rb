class RefreshDailyJob < ApplicationJob
  def perform
    User.all.each do |user|
      Network.where(user: user).have_chain.actived.each do |n|
        Wallet.where(user: user).bep20.each do |w|
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
    Token.where(network: Network.have_chain, balance: 0).destroy_all
    Token.where(network: Network.have_chain, contract_name: Trash.pluck(:contract_name)).destroy_all

    # ONTOLOGY
    User.all.each do |user|
      network = Network.ontology(user)

      Wallet.where(user: user).ontology.each do |w|
        items = RequestOntologyWalletApi.call(address: w.address).result
        next if items.nil?

        items.each do |item|
          next unless item.asset_name
  
          token = Token.find_or_create_by(
            wallet: w,
            network: network,
            contract_name: item.asset_name,
            contract_ticker_symbol: item.asset_name,
            contract_address: item.contract_hash
          )
          token.update(balance: item.balance)
        end
      end
    end
  end
end
