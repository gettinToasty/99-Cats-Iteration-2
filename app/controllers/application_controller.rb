class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def log_in(user)
    user.device = request.env["HTTP_USER_AGENT"]
    user.ensure_session_token
    session[:session_token] = user.sessions.find_by(device: user.device).session_token
  end

  def log_out
    current_user.reset_session_token! if current_user
  end

  def current_user
    @current_user = Session.find_by(session_token: session[:session_token]).user if Session.find_by(session_token: session[:session_token])
  end

end
