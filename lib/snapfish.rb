require 'snapfish/base'
require 'snapfish/asset'
require 'snapfish/album'
require 'snapfish/album_collection'

module Snapfish
  API_BASE_URL = 'https://assets-aus.snapfish.com/pict/v2/'

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
