# frozen_string_literal: true

class PricesController < ApplicationController
  def index
    @prices = Price.all.order(:contract_name)
    @networks = Network.have_chain.where(user: current_user).actived
  end
end
