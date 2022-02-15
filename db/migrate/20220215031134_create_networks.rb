class CreateNetworks < ActiveRecord::Migration[6.1]
  def change
    create_table :networks do |t|
      t.string :network_name, null: false
      t.integer :chain_id, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
