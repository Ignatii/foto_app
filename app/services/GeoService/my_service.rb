# service for interact with googleapi
require 'net/http'
require 'uri'
require 'json'

module GeoService
  class MyService
    def initialize(coord)
      @coord = coord
    end

    def take_country
      return response_parsed['countryName'] if response_parsed['countryName'].present?
      return 'Invalid coordinates' if response_parsed['status']['message'].present?
    rescue JSON::ParserError
      'Invalid response'
    rescue SocketError => se # StandardError::SocketError
      'Something with HTTP connection' + se
    end

    private

    def response_parsed
      result = Net::HTTP.get_response(uri_connect)
      @response_parsed ||= JSON.parse(result.body)
    end

    def uri_connect
      str = 'http://ws.geonames.org/countryCodeJSON?lat='\
            "#{@coord[:lat]}&lng=#{@coord[:lon]}&username=ignat"
      @uri_connect = URI(str)
    end
  end
end
