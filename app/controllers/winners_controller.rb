# frozen_string_literal: true

class WinnersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    return if params[:wallet_string].blank?

    winners = CheckWinners.call(params[:wallet_string], current_user).result
    history = History.create(user: current_user, wallets: winners)
    redirect_to history_path(history)
  end
end
