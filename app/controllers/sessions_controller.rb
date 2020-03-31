class SessionsController < ApplicationController
  before_action :ensure_authenticated, only: :destroy
  before_action :ensure_not_authenticated, only: [:new, :create]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    respond_to do |format|
      if @user.present? && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        format.html { redirect_to root_path, notice: t('notices.login_success') }
      else
        format.html { redirect_to login_path, alert: t('alerts.login_fail') }
      end
    end
  end

  def destroy
    session.delete(:user_id)
    respond_to do |format|
      format.html { redirect_to root_path, notice: t('notices.logout_success') }
    end
  end

  private

  def ensure_not_authenticated
    redirect_to account_path, alert: t('alerts.already_logged_in') if logged_in?
  end
end
