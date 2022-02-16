class CreateHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :histories do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :wallets, array: true, default: []
      t.text :note, default: ''

      t.timestamps
    end
  end
end
