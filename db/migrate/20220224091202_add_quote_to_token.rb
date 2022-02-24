class AddQuoteToToken < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :quote_rate, :decimal, null: true
    add_column :tokens, :quote_rate_24h, :decimal, null: true
  end
end
