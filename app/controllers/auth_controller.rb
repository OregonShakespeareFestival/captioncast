class AuthController < ApplicationController

  def login
    session[:user] = "test"
  end

  def logout
    session[:user] = nil
  end

end
