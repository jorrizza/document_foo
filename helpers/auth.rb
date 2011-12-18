helpers do
  def logged_in?
    !session[:username].nil?
  end

  def is_admin?
    return false if !logged_in?

    @me.role == :admin
  end

  def auth!
    redirect '/' unless logged_in?
  end

  def auth_admin!
    redirect '/' unless is_admin?
  end
end
