class UsersController < ApplicationController
  # Executes methods before specified actions.
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
#  before_action :admin_user,     only: :destroy

  # Gathers users for user list.
  def index
    @users = User.paginate(page: params[:page])
  end

  # User list.
  def show
    @user = User.find(params[:id])
  end

  # New user.
  def new
  	@user = User.new
  end

  # First time login.
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
    	flash[:success] = "Welcome to GIS toolkit"
      redirect_to @user
    else
      render 'new'
    end
  end

  # Edit user info.
  def edit
    @user = User.find(params[:id])
  end

  # If the new info is valid updates all the attributes
  # from the passed-in hash and saves the record.
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # Permanently deletes user.
  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      log_out
      @user.destroy
      redirect_to root_url
    else
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end
  end

  private

    # Strong parameters
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      if @user != current_user
        redirect_to(root_url) unless current_user.admin?
      end
    end

end
