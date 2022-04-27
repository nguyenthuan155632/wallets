# frozen_string_literal: true

class Token < ApplicationRecord
  belongs_to :wallet
  belongs_to :network
end
