class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.references :wallet, foreign_key: true, null: false
      t.references :network, foreign_key: true, null: false
      t.string :contract_name, null: false
      t.string :contract_ticker_symbol, null: false
      t.string :contract_address
      t.string :logo_url
      t.decimal :balance, default: 0, null: false

      t.timestamps
    end
  end
end
