class UsersController < ApplicationController
  include UsersHelper
  
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:index, :show, :edit, :update]
  before_action :logged_in_as_admin, only: [:index]
  before_action :can_destroy, only: [:destroy]
  def index
    if isAdmin?
      @q_users = User.where.not(role: "SuperAdmin").ransack(params[:q])
    else
      @q_users = User.ransack(params[:q])
    end
    @users = @q_users.result().paginate(page: params[:page])
  end
  def show
    @user = User.find(params[:id])
  end
  def new
    @user = User.new
  end
  def edit
    @user = User.find(params[:id])
  end
  def create
    @user = User.new(user_params)
    if @user.save
      if logged_in?
        flash[:success] = "New user account created!"
      else
        log_in @user
        flash[:success] = "Welcome to Car Rental App!"
      end
      redirect_to @user
    else
      flash[:danger] = "Failed to sign up"
      render :new
    end
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:sucess] = "Profile updated."
      redirect_to @user
    else
      render :edit
    end
  end
  def destroy
    @user = User.find(params[:id])
    reservations = Reservation.where(user_id: @user.id)
    reservations.destroy_all
    @user.destroy
    flash[:success] = 'User deleted.'
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :rentalCharge, :notification, :available)
    end
    def can_destroy
      @user = User.find(params[:id])
      if ["root_superadmin@email.com", "root_admin@email.com"].include?(@user.email) || current_user?(@user)
        flash[:danger] = 'Prefigured admin or self cannot be deleted!'
        redirect_to @user
      end
      reservation_in_use = Reservation.where(user_id: @user.id)
                                .where.not(reservationStatus: ['Complete', 'Cancel']).size != 0
      if !@user.available || reservation_in_use
        flash[:danger] = @user.name + ' is not clean of reservation, and cannot be deleted now!'
        redirect_to @user
      end
    end
    
end
