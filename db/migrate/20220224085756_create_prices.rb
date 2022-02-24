class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices do |t|
      t.string :contract_name, null: false
      t.string :contract_ticker_symbol, null: false
      t.decimal :quote_rate, default: 0, null: false
      t.decimal :quote_rate_24h, default: 0, null: false

      t.timestamps
    end
  end
end
