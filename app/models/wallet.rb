class Wallet < ApplicationRecord
  has_many :tokens, dependent: :destroy
  belongs_to :user

  enum address_type: {
    bep20: 'BEP20',
    ontology: 'Ontology'
  }

  validates :address, uniqueness: { scope: :user_id, case_sensitive: false, message: 'should be inserted once!' }
end
