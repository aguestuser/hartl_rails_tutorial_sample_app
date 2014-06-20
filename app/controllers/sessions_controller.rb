class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # sign in user & redirect to user's show page
    else
      flash[:error] = 'Invalid email/password combination'
      render 'new'
      # create error message & re-render sign-in form
    end
  end

  def destroy
    
  end

end
