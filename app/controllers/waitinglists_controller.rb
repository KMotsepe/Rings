class WaitinglistsController < ApplicationController

  def index
    if isAdmin? || isSuperAdmin?
      @waitinglists = Waitinglist.all
    else
      @waitinglists = Waitinglist.where(:user_id => session[:user_id]) || [] # return current user record or empty
    end
  end

  def show
    @waitinglist = Waitinglist.find(params[:id])
  end

  def new
    @waitinglist = Waitinglist.new
  end

  def edit
    @waitinglist = Waitinglist.find(params[:id])
  end

  def create
    if true
      @waitinglist = Waitinglist.new(waitinglist_params)
      if @waitinglist.save
          flash[:success] = 'Email notification was successfully created.'
          redirect_to @waitinglist
      end
    end
  end

  def update
    if @waitinglist.update(waitinglist_params)
      flash[:success] = 'Email notification was successfully updated.'
      redirect_to @waitinglist
    else
      render :edit
    end
  end

  def destroy
    @waitinglist = Waitinglist.find(params[:id])
    @waitinglist.destroy
    flash[:success] = 'Email notification deleted!'
    redirect_to waitinglists_url
  end



  def cancel
    @waitinglist = Waitinglist.find(params[:id])
    if @waitinglist.update_attributes(:status => "Cancel")
      flash[:success] = "Email notification was successfully canceled!"
      redirect_to @waitinglist
    end
  end

  private
    def waitinglist_params
      params.require(:waitinglist).permit(:user_id, :car_id, :status)
    end
  
end