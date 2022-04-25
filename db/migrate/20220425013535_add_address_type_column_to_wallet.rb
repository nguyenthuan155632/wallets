class AddAddressTypeColumnToWallet < ActiveRecord::Migration[6.1]
  def change
    add_column :wallets, :address_type, :string, default: 'BEP20'
  end
end
