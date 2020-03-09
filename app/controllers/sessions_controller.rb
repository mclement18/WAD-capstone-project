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
        format.html { redirect_to root_path, notice: 'Successfully logged in!' }
      else
        format.html { redirect_to login_path, motice: 'Wrong email/password combination.' }
      end
    end
  end

  def destroy
    session.delete(:user_id)
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Successfully logged out!' }
    end
  end

  private

  def ensure_not_authenticated
    redirect_to account_path, notice: 'You are already logged in.' if logged_in?
  end
end
