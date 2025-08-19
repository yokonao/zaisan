class AccountsController < ApplicationController
  before_action :require_login
  before_action :set_account, only: [ :show, :edit, :update, :destroy ]

  def show
    @snapshots = @account.account_snapshots.order(recorded_at: :desc).limit(30)
  end

  def create
    @account = current_user.accounts.build(account_params)
    
    respond_to do |format|
      if @account.save
        format.html { redirect_to dashboard_path, notice: "口座を作成しました" }
        format.turbo_stream { redirect_to dashboard_path, notice: "口座を作成しました" }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to dashboard_path, notice: "口座情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to dashboard_path, notice: "口座を削除しました"
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:account_type, :name, :description)
  end
end
