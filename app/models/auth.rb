class Auth

  require 'rest-client'
  require 'xmlsimple'

  # validates whether the user belongs to the specified group
  def self.is_member_of(username, groupname)
    crowd_username = Rails.configuration.auth["crowd_username"]
    crowd_password = Rails.configuration.auth["crowd_password"]
    url = Rails.configuration.auth["crowd_base_url"]
    rest_auth = "Basic " + Base64.encode64("#{crowd_username}:#{crowd_password}")
    rest_url = "#{url}crowd/rest/usermanagement/latest/user/group/direct?username=#{username}&groupname=#{groupname}"
    begin
      response2 = RestClient.get(rest_url, :Content_Type => :xml, :Accept => :xml, :Authorization => rest_auth)
    rescue => e
      return false
    end
    return true
  end

  # validates whether the username and password is correct for the specified user
  def self.is_user(username, password)
    crowd_username = Rails.configuration.auth["crowd_username"]
    crowd_password = Rails.configuration.auth["crowd_password"]
    url = Rails.configuration.auth["crowd_base_url"]
    rest_auth = "Basic " + Base64.encode64("#{crowd_username}:#{crowd_password}")
    rest_url = "#{url}crowd/rest/usermanagement/latest/authentication?username=#{username}"
    rest_body = "<?xml version='1.0' encoding='UTF-8'?><password><value>#{password}</value></password>"
    begin
      response = RestClient.post(rest_url, rest_body, :Content_Type => :xml, :Accept => :xml, :Authorization => rest_auth)
    rescue => e
      return false
    end
    return XmlSimple.xml_in(response)
  end

end
