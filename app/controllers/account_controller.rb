class AccountController < ApplicationController
  before_action :ensure_authenticated

  def show
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if current_user.update(account_params)
        format.html { redirect_to account_path, notice: t('notices.account_updated') }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_user.soft_delete
        session.delete(:user_id) 
        format.html { redirect_to root_path, notice: t('notices.account_deleted') }
      else
        format.html { redirect_to users_path, alert: t('alerts.account_deletion_fail') }
      end
    end
  end

  private

  def account_params
    params.require(:user).permit(:email, :password, :name, :avatar)
  end
end
