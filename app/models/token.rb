# frozen_string_literal: true

class Token < ApplicationRecord
  ONTOLOGY_CONTRACT_ADDRESS = %w[
    0100000000000000000000000000000000000000
    0200000000000000000000000000000000000000
  ].freeze

  belongs_to :wallet
  belongs_to :network
end
