class WinnersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    return if params[:wallet_string].blank?

    wallets = []
    winner_list = params[:wallet_string].split("\r\n").compact.uniq
    winner_list.each do |wn|
      Wallet.where(user: current_user).each do |wallet|
        start_string, end_string = wn.gsub(/\*+/, '*').split('*').map(&:downcase)
        wallets << wallet.id if wallet.address.downcase.include?(start_string) && wallet.address.downcase.include?(end_string)
      end
    end
    history = History.create(user: current_user, wallets: wallets)
    redirect_to history_path(history)
  end
end