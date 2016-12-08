class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def log_in(user)
    token = SecureRandom.urlsafe_base64(128)
    device = request.env["HTTP_USER_AGENT"]
    @session = Session.new(user_id: user.id,
                             session_token: token,
                             device: device
                            )
    @session.save
    session[:session_token] = @session.session_token
  end

  def log_out
    device = request.env["HTTP_USER_AGENT"]
    @session = Session.find_by(device: device)
    @session.destroy if current_user
  end

  def current_user
    current_session = Session.find_by(session_token: session[:session_token])
    @current_user = current_session.user if current_session
  end

end
