class AccountsController < ApplicationController
  before_action :require_login
  before_action :set_account, only: [ :show, :edit, :update, :destroy ]

  def index
    @accounts = current_user.accounts
  end

  def show
    @snapshots = @account.account_snapshots.order(recorded_at: :desc).limit(30)
  end

  def new
    @account = current_user.accounts.build
  end

  def create
    @account = current_user.accounts.build(account_params)
    if @account.save
      redirect_to @account, notice: "口座を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: "口座情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: "口座を削除しました"
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:account_type, :name, :description)
  end
end
