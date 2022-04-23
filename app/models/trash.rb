class Trash < ApplicationRecord
  after_create :remove_trash_tokens

  private

  def remove_trash_tokens
    Token.where(contract_name: contract_name).destroy_all
  end
end
