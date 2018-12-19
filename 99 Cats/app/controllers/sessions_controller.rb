class SessionsController < ApplicationController
  def new
    render :new
  end

  def create

    username = params[:user][:username]
    password = params[:user][:password]


    @user = User.find_by_credentials(username, password)
    
    if @user
      redirect_to session_new_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

end