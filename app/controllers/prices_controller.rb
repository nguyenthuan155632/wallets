class PricesController < ApplicationController
  def index
    @prices = Price.all.order(:contract_name)
    @networks = Network.where(user: current_user).actived
  end
end
