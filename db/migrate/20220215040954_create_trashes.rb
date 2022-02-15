class CreateTrashes < ActiveRecord::Migration[6.1]
  def change
    create_table :trashes do |t|
      t.string :contract_name, null: false

      t.timestamps
    end
  end
end
