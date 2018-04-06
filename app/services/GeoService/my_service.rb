#service for interact with googleapi
require 'net/http'
require 'uri'
require 'json'

module GeoService
  class MyService
    
    def initialize(coord)
      @coord = coord
    end

    def get_country
      begin
        uri = URI("http://ws.geonames.org/countryCodeJSON?lat=#{@coord[:lat]}&lng=#{@coord[:lon]}&username=ignat")
        result = Net::HTTP.get_response(uri)
        # response = open("http://ws.geonames.org/countryCodeJSON?lat=#{@coord[:lat]}&lng=#{@coord[:lon]}&username=ignat").read
        response_parsed = JSON.parse(result.body)
        return response_parsed["countryName"] unless response_parsed["countryName"].nil?
        return 'Invalid coordinates' unless response_parsed['status']["message"].nil?
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