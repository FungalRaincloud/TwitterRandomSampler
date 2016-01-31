require 'net/https'
require 'uri'
require 'oauth'
require 'json'
require_relative 'environment'

consumer_key = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET)
access_token = OAuth::Token.new(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

address = URI("https://stream.twitter.com/1.1/statuses/sample.json?delimited=length&language=#{ARGV.empty? ? '' : ARGV[0]}")
http = Net::HTTP.new address.host, address.port
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
request = Net::HTTP::Get.new address.request_uri
request.oauth! http, consumer_key, access_token
body = ''
puts "Spooling up the request. This might take a second."
http.request request do |response|
	response.read_body do |chunk|
		body += chunk
		num_bytes = body.split("\n").first.to_i
		body = body.split("\n")[1..-1].join("\n")
		json_blob = body.slice 0, num_bytes
		if num_bytes > 0
			parsed = JSON.parse(json_blob)
			if parsed["text"] != nil
				puts parsed["user"]["screen_name"]
				puts parsed["text"]
				puts parsed["created_at"]
				sleep 1
			end
		end
	end
end

