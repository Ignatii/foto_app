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
      begin
        uri = URI("http://ws.geonames.org/countryCodeJSON?lat=#{@coord[:lat]}&lng=#{@coord[:lon]}&username=ignat")
        result = Net::HTTP.get_response(uri)
        response_parsed = JSON.parse(result.body)
        bool_res = response_parsed['countryName'].nil?
        bool_inv = response_parsed['status']['message'].nil?
        return response_parsed['countryName'] unless bool_res
        return 'Invalid coordinates' unless bool_inv
      rescue Exception => e
        if e.class.to_s == 'SocketError'
          return 'Something with HTTP connection. Try later.'
        elsif e.class.to_s == 'ParserError'
          return 'Cant parse response, talk with administrator'
        end
      end
    end
  end
end
