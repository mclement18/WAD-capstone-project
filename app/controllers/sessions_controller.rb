class SessionsController < ApplicationController
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
end
