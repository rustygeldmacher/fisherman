require 'snapfish/base'
require 'snapfish/asset'
require 'snapfish/album'
require 'snapfish/album_collection'
require 'snapfish/downloader'

module Snapfish
  LOGIN_BASE_URL = 'https://www.snapfish.com/'
  API_BASE_URL = 'https://assets-aus.snapfish.com/pict/v2/'

  def self.login
    connection = Faraday.new(url: LOGIN_BASE_URL) do |builder|
      builder.request :url_encoded
      builder.request :multipart
      builder.use :cookie_jar
      builder.adapter Faraday.default_adapter
    end

    # Grab our cookies
    connection.get('photo-gift/loginto')

    user_data = connection.get('/photo-gift/api/v1/user-data').body
    csrf_token = user_data.match(/securityCSRFToken='([\h-]*)'/)[1]

    login_response = connection.post('/photo-gift/loginto',
      submit: true,
      SECURITY_CSRFTOKEN: csrf_token,
      EmailAddress: 'russell.geldmacher@gmail.com',
      Password: 'qwerty'
    )

    puts login_response.status
    puts login_response.headers
  end

  def self.connect(token)
    connection = Faraday.new(url: API_BASE_URL) do |conn|
      conn.request :json
      conn.response :json
      conn.adapter Faraday.default_adapter
    end

    connection.headers['Authorization'] = token
    connection.headers['access_token'] = token
    connection.headers['Accept'] = 'application/json'

    Snapfish::Base.connection = connection
  end
end
