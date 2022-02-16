class WinnersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def create
    return if params[:wallet_string].blank?

    wallets = []
    winner_list = params[:wallet_string].split("\r\n").compact.uniq
    winner_list.each do |wn|
      Wallet.where(user: current_user).each do |wallet|
        start_string, end_string = wn.gsub(/\*+/, '*').split('*')
        wallets << wallet.id if wallet.address.include?(start_string) && wallet.address.include?(end_string)
      end
    end
    History.create(user: current_user, wallets: wallets)
    redirect_to histories_path
  end
end
