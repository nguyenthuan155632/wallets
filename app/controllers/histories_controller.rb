# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @histories = History.where(user: current_user).order(created_at: :desc)
  end

  def show
    @history = History.find(params[:id])
  end
end
