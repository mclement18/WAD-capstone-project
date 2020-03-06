class AccountController < ApplicationController
  before_action :ensure_authenticated

  def show
  end
  
  def edit
  end

  def update
    respond_to do |format|
      if current_user.update(account_params)
        format.html { redirect_to account_path, notice: 'Account successfully updated!' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if current_user.soft_delete
        session.delete(:user_id) 
        format.html { redirect_to root_path, notice: 'Account successfuly deleted!' }
      else
        format.html { redirect_to users_path, alert: 'Unable to delete account.' }
      end
    end
  end

  private

  def account_params
    params.require(:user).permit(:email, :password, :name, :avatar)
  end
end
