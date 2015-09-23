helpers do
  def current_user(user)
    if session[:user_id] && (user.password_digest == BCrypt::Password.create(params[:password]))
      @current_user = user
    end
  end
end
