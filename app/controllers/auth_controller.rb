class AuthController < ApplicationController
  require 'rest-client'
  require 'xmlsimple'

  def new
  end

  def create
    if Auth.is_member_of(params[:username], "captioncast")
      if user = Auth.is_user(params[:username], params[:password])
        session[:user] = user['display-name'][0]
        redirect_to "/"
      else
        flash[:error] = "Invalid Username or Password."
        redirect_to "/login"
      end
    else
      flash[:error] = "Access to this application is not permitted."
      redirect_to "/login"
    end
  end

  def destroy
    session[:user] = nil
    redirect_to "/login"
  end

end
