class DashboardController < ApplicationController
  before_action :require_login

  def index
    @accounts = current_user.accounts.preload(:account_snapshots)
    @total_amount = @accounts.sum { |account| account.latest_amount }
  end
end
