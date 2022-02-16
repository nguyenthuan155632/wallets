class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @histories = History.where(user: current_user).order(created_at: :desc)
  end
end
