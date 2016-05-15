class AuthController < ApplicationController
  require 'rest-client'
  require 'xmlsimple'

  def new
  end

  def create
    # generate rest request for authentication with crowd
    rest_auth = "Basic " + Base64.encode64("broken-props:admin")
    rest_url = "https://crowd.osfashland.org/crowd/rest/usermanagement/latest/authentication?username=#{params[:username]}"
    rest_body = "<?xml version='1.0' encoding='UTF-8'?><password><value>#{params[:password]}</value></password>"
    # send request
    begin
      response = RestClient.post(rest_url, rest_body, :Content_Type => :xml, :Accept => :xml, :Authorization => rest_auth)
    rescue => e
      # failed login
      redirect_to "/login"
      return
    end
    # get the user hash from the response
    response_hash = XmlSimple.xml_in(response)
    # set the current user's display name
    session[:user] = response_hash['display-name'][0]
    # redirect back to the homepage
    redirect_to "/"
  end

  def destroy
    session[:user] = nil
    redirect_to "/login"
  end

end
