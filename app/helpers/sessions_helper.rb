module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  # TODO: Make it so logging in from elsewhere doesn't change the remember
  # token, effectively logging the user out from anywhere else.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the user via the current session or a remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      get_current_user_from_session(user_id)
    elsif (user_id = cookies.signed[:user_id])
      get_current_user_from_cookie(user_id)
    end
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns true if a user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to the stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL that the user was trying to access.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  private

  def get_current_user_from_session(user_id)
    return @current_user if @current_user

    @current_user = User.find_by(id: user_id)
    logger.info do
      "User #{user_id} (#{@current_user.email}) inferred from session."
    end
    @current_user
  end

  def get_current_user_from_cookie(user_id)
    user = User.find_by(id: user_id)
    return unless user&.authenticated?(:remember, cookies[:remember_token])

    log_in user
    logger.info { "Logged in user #{user_id} (#{user.email}) via cookie." }
    @current_user = user
  end
end
