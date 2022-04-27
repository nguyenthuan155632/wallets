# frozen_string_literal: true

class Price < ApplicationRecord
  default_scope -> { where.not(contract_name: Trash.pluck(:contract_name)) }
end
