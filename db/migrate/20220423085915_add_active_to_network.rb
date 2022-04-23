class AddActiveToNetwork < ActiveRecord::Migration[6.1]
  def change
    add_column :networks, :active, :boolean, default: true
  end
end
