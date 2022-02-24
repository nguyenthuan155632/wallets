class RemoveTokenForeignKey < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :histories, :users
    remove_foreign_key :networks, :users
    remove_foreign_key :tokens, :networks
    remove_foreign_key :tokens, :wallets
    remove_foreign_key :wallets, :users
  end
end
