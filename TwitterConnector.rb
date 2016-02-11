require 'net/https'
require 'uri'
require 'oauth'
require 'json'
require_relative 'environment'

#TODO: ensure names meet convention, gemify?
class TwitterConnector
  def initialize stream_source: "sample.json", language: "en", filter: ""
    @consumer_key = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET)
    @access_token = OAuth::Token.new(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
    @address = URI(URI.escape("https://stream.twitter.com/1.1/statuses/#{stream_source}?delimited=length&language=#{language}&track=#{filter}"))
  end

  def connect
    @http = Net::HTTP.new @address.host, @address.port
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new @address.request_uri
    request.oauth! @http, @consumer_key, @access_token
    body = ''
    retries = 5
    begin
      print "Spooling up the request. This might take a second.\n\n\r"
      @http.request request do |response|
        response.read_body do |chunk|
          body += chunk
          num_bytes = body.split("\n").first.to_i
          body = body.split("\n")[1..-1].join("\n")
          json_blob = body.slice 0, num_bytes
          if num_bytes > 0
            parsed = JSON.parse(json_blob)
            if parsed["text"] != nil
              # TODO: maybe use curses to make this a little cleaner/easier to read?
              #
              print "#{parsed["user"]["screen_name"]}\t\t#{parsed["created_at"]}\n\r#{parsed["text"].gsub("\n", "\n\r")}\n\n\n\r"
              sleep 1
            end
          end
        end
      end
    rescue EOFError
      print "Stream Lost. Retries remaining: #{retries-=1}"
      sleep 5
      if !retries.zero?
        retry
      end
    end
  end
  def close
    @http.finish if @http.started?
  end
end
