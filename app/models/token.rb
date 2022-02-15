class Token < ApplicationRecord
  belongs_to :wallet
  belongs_to :network

  default_scope -> { where(contract_name: Trash.pluck(:contract_name)) }
end
