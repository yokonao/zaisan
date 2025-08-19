class AccountSnapshotsController < ApplicationController
  before_action :require_login
  before_action :set_account
  before_action :set_snapshot, only: [ :destroy ]

  def new
    @snapshot = @account.account_snapshots.build
  end

  def create
    @snapshot = @account.account_snapshots.build(snapshot_params)
    if @snapshot.save
      redirect_to dashboard_path, notice: "残高を記録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @snapshot.destroy
    redirect_to dashboard_path, notice: "スナップショットを削除しました"
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:account_id])
  end

  def set_snapshot
    @snapshot = @account.account_snapshots.find(params[:id])
  end

  def snapshot_params
    params.require(:account_snapshot).permit(:amount, :recorded_at)
  end
end
