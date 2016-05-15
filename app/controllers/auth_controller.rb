class AuthController < ApplicationController

  def new
  end

  def create
    session[:user] = "test"
    redirect_to "/"
  end

  def destroy
    session[:user] = nil
    redirect_to "/login"
  end

end
