require_relative 'TwitterConnector'

class TermTwitterClient
  PAUSE_KEYS = ' pP'
  QUIT_KEYS = 'qQ'
  ARG_KEYS = 'cC'
  HELP_KEYS = 'hH?'
  def initialize
    @paused = false
    @tc = TwitterConnector.new
    start
  end
  def start
    create_thread
    while @connection.alive? do
      respond_to_keypresses
    end
  end

  def get_key
    begin
      system('stty raw -echo')
      char = (STDIN.read_nonblock(1) rescue "\0") # "\0" is the ASCII null character.
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
    print "\n'#{HELP_KEYS}' - display this help message"
    print "'#{ARG_KEYS}' - change twitter language/filter/stream type"
    print "'#{QUIT_KEYS}' - quit"
    print "'#{PAUSE_KEYS}' - pause"
    print "Press space to continue execution."
    pause if !@paused
  end

  def change_args
    @tc.close
    print "\nstream <sample.json>:"
    stream = gets.chomp
    stream = 'sample.json' if stream.empty?
    print "search filter (space delimited) <none>:"
    #TODO: change to a url encoder, add same to stream and language
    filter = gets.chomp
    print "language <en>:"
    language = gets.chomp
    #TODO: make check for valid language by declaring a constant in TwitterConnector?
    language = 'en' if language.empty?
    print "stream: #{stream}, filter: #{filter}, language: #{language}\n"
    @tc = TwitterConnector.new stream_source: stream, filter: filter, language: language
    create_thread
  end

  def pause
    @paused = !@paused
    @tc.close
    while @paused
      respond_to_keypresses
    end
    create_thread
  end

  def create_thread
    @connection = Thread.new{@tc.connect} if @connection.nil? || !@connection.alive?
  end
end

TermTwitterClient.new
