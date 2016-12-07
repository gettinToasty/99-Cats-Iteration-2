class UsersController < ApplicationController
  before_action :already_logged_in, only: :new


  def already_logged_in
    redirect_to cats_url if @current_user
  end

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:messages] = ["Welcome to 99 cats you lonely soul."]
      redirect_to user_url(@user)
    else
      flash.now[:messages] = @user.errors.full_messages
      render :new
    end
  end

  def show
    if params[:id].to_i == current_user.id
      @user = User.find(params[:id])
      render :show
    else
      flash[:messages] = ["Stop creepin"]
      redirect_to cats_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
