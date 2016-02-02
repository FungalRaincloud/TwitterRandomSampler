require 'net/https'
require 'uri'
require 'oauth'
require 'json'
require_relative 'environment'

PAUSE_KEYS = ' '
QUIT_KEYS = 'qQ'
@paused = false

def get_key
  begin
    system('stty raw -echo') 
    char = (STDIN.read_nonblock(1).ord rescue 0) # 0 is the ASCII null character.
  ensure
    system('stty -raw echo')
  end
  return char.chr
end

def respond_to_keypresses
  keypress = get_key
  pause if PAUSE_KEYS.include? keypress
  exit if QUIT_KEYS.include? keypress
end
def pause
  @paused = !@paused
  while @paused
    respond_to_keypresses
  end
end

consumer_key = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET)
access_token = OAuth::Token.new(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

address = URI("https://stream.twitter.com/1.1/statuses/sample.json?delimited=length&language=#{ARGV.empty? ? '' : ARGV[0]}")
http = Net::HTTP.new address.host, address.port
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
request = Net::HTTP::Get.new address.request_uri
request.oauth! http, consumer_key, access_token
body = ''
retries = 5
begin
  puts "Spooling up the request. This might take a second.\n\n"
  http.request request do |response|
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
          puts "#{parsed["user"]["screen_name"]}\t\t#{parsed["created_at"]}\n#{parsed["text"]}\n\n\n"
          respond_to_keypresses
          sleep 1
        end
      end
    end
  end
rescue EOFError
  puts "Stream Lost. Retries remaining: #{retries-=1}"
  sleep 5
  if !retries.zero?
    retry
  end
end
