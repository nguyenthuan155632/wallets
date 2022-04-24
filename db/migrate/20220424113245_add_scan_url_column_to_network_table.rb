class AddScanUrlColumnToNetworkTable < ActiveRecord::Migration[6.1]
  def change
    add_column :networks, :scan_url, :text, default: ''
  end
end
