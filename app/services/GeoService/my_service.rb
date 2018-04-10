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
        str = 'http://ws.geonames.org/countryCodeJSON?lat='\
              "#{@coord[:lat]}&lng=#{@coord[:lon]}&username=ignat"
        uri = URI(str)
        result = Net::HTTP.get_response(uri)
        response_parsed = JSON.parse(result.body)
        bool_res = response_parsed['countryName'].nil?
        bool_inv = response_parsed['status']['message'].nil?
        return response_parsed['countryName'] unless bool_res
        return 'Invalid coordinates' unless bool_inv
      rescue Exception => e
        ex_cl = e.class.to_s
        # if e.class.to_s == 'SocketError'
        return 'Something with HTTP connection/' if ex_cl == 'SocketError'
        # elsif e.class.to_s == 'ParserError'
        return 'Cant read response,contact admin' if ex_cl == 'ParserError'
        # end
      end
    end
  end
end
