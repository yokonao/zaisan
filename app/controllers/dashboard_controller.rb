class DashboardController < ApplicationController
  before_action :require_login

  def index
    @accounts = current_user.accounts.includes(:account_snapshots)
    @total_amount = calculate_total_amount
  end

  private

  def calculate_total_amount
    current_user.accounts.sum { |account| account.latest_amount }
  end
end
