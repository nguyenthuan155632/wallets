class Token < ApplicationRecord
  belongs_to :wallet
  belongs_to :network
end
