class TokensController < ApplicationController
  before_action :set_token, only: %i[trash]

  def trash
    Trash.find_or_create_by(contract_name: params[:contract_name])
  end

  private
    def set_token
      @token = Token.find(params[:id])
    end
end
  