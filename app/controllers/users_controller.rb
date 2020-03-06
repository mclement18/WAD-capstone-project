class UsersController < ApplicationController
  before_action :ensure_authenticated, only: [:index, :edit, :update, :destroy]
  before_action :ensure_admin, only: [:index, :edit, :update, :destroy]
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all.active
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to root_path, notice: 'Successfully signed up!' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update admin_params
        format.html { redirect_to edit_user_path(@user), notice: 'User succesfully updated!' }
      else
        format.html {render :edit }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user.soft_delete
        if @user.id == current_user.id
          session.delete(:user_id) 
          format.html { redirect_to root_path, notice: 'You successfuly deleted your account!' }
        else
          format.html { redirect_to users_path, notice: 'User successfuly deleted!' }
        end
      else
        format.html { redirect_to users_path, alert: 'Unable to delete user.' }
      end
    end
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_admin
    redirect_to root_path unless current_user.role == 'admin'
  end

  def user_params
    params.require(:user).permit(:email, :password, :name, :avatar)
  end

  def admin_params
    params.require(:user).permit(:name, :avatar, :role)
  end
end
