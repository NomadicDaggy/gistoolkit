class SessionsController < ApplicationController

  # Renders sessions/new.html.erb
  def new
  end

  # Logs in user, if info correct.
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # Logs out user.
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
