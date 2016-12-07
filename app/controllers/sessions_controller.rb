class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_credentials(session_params[:username], session_params[:password])
    if user
      log_in(user)
      flash[:messages] = ["Welcome back"]
      redirect_to user_url(user)
    else
      flash.now[:messages] = ["Invalid user"]
      render :new
    end
  end

  def destroy
    log_out
    redirect_to cats_url
  end

  private

  def session_params
    params.require(:sessions).permit(:username, :password)
  end

end
