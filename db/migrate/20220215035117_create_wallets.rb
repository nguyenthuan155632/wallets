class CreateWallets < ActiveRecord::Migration[6.1]
  def change
    create_table :wallets do |t|
      t.string :address, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
