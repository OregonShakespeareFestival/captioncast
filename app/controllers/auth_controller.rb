class AuthController < ApplicationController

  def new
  end

  def create
    session[:user] = "test"
  end

  def destroy
    session[:user] = nil
  end

end
