class Wallet < ApplicationRecord
  has_many :tokens, dependent: :destroy
  belongs_to :user
end
