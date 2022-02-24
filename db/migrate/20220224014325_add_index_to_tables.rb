class AddIndexToTables < ActiveRecord::Migration[6.1]
  def change
    add_index :wallets, %i[address user_id], unique: true
    add_index :tokens, :contract_name
    add_index :trashes, :contract_name
  end
end
