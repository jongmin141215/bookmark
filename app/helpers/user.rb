module UserHelpers
  helpers do
    def current_user
      @current_user = User.get(session[:user_id])
    end
  end
end

helpers UserHelpers
