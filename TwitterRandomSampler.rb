require 'net/https'
require 'uri'
require 'oauth'
require 'json'
require_relative 'environment'
require_relative 'TwitterConnector'

PAUSE_KEYS = ' pP'
QUIT_KEYS = 'qQ'
ARG_KEYS = 'cC'
HELP_KEYS = 'hH?'
@paused = false

def get_key
  begin
    system('stty raw -echo')
    char = (STDIN.read_nonblock(1) rescue "\0") # '\0' is the ASCII null character.
  ensure
    system('stty -raw echo')
  end
  return char
end

def respond_to_keypresses
  keypress = get_key
  pause if PAUSE_KEYS.include? keypress
  change_args if ARG_KEYS.include? keypress
  help if HELP_KEYS.include? keypress
  exit if QUIT_KEYS.include? keypress
end

def help
  puts "\n'#{HELP_KEYS}' - display this help message"
  puts "'#{ARG_KEYS}' - change twitter language/filter/stream type"
  puts "'#{QUIT_KEYS}' - quit"
  puts "'#{PAUSE_KEYS}' - pause"
  puts "Press space to continue execution."
  pause if !@paused
end

def change_args
  print "\nstream <sample.json>:"
  stream = gets.chomp
  stream = 'sample.json' if stream.empty?
  print "search filter (space delimited) <none>:"
  #TODO: change to a url encoder, add same to stream and language
  filter = gets.chomp.gsub('#', "%27").gsub(' ', '%20')
  print "language <en>:"
  language = gets.chomp
  #TODO: make check for valid language by declaring a constant in Twitter_Connector?
  language = 'en' if language.empty?
  puts "stream: #{stream}, filter: #{filter}, language: #{language}"
  @tc = Twitter_Connector.new stream_source: stream, filter: filter, language: language
end

def pause
  @paused = !@paused
  while @paused
    respond_to_keypresses
  end
end

@tc = Twitter_Connector.new
while true do
  #@tc.connect
  respond_to_keypresses
end
