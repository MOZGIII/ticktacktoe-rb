require 'bundler/setup'
Bundler.require(:default)

$: << "../lib"

# Load our framework
require "load"

module App
  Options = Struct.new(:algorithm, :play_as)

  module_function

  def init!(argv)
    @options = Options.new

    case argv.shift
    when "minmax"
      @options.algorithm = MinMaxSearch
    when "alphabeta"
      @options.algorithm = AlphaBetaSearch
    end

    check_options!
  end

  def options
    @options
  end

  def check_options!
    unless @options.algorithm
      puts "Usage: #{$0} algorithm"
      puts
      puts "Where algorithm is minmax or alphabeta"
      exit 1
    end
  end
end

class BoardDrawer
  def initialize(board)
    @board = board
    @size = @board.class::SQRT_SIZE
  end

  def render_spacer
    "+---" * @size + "+"
  end

  def render_line(n)
    n *= @size
    arr = []
    for i in 0...@size do
      arr << board_symbol(n + i)
    end
    "| #{arr.join(" | ")} |"
  end

  def board_symbol(n)
    @board.symbol_at(n) || " "
  end

  def render
    buffer = render_spacer + "\n"

    @size.times do |i|
      buffer << render_line(i) << "\n"
      buffer << render_spacer << "\n"
    end

    buffer
  end

  def draw
    puts render
  end
end

class Game
  INVALID_INPUT_MESSAGE = "Enter two numbers between 1 and #{Board::SQRT_SIZE}! Example: \"> 1 1\""

  def initialize(human_plays_as = X)
    @board = Board.new
    @current_symbol = X
    @human_plays_as = human_plays_as
  end

  def humans_turn?
    @current_symbol == @human_plays_as
  end

  def bot_turn
    state = Searcher.search(@board, @current_symbol)
    puts "AI: #{state.action}"
    @board = state.board
  end

  def human_turn
    coords = nil
    until coords
      puts
      print "> "
      line = gets.chomp
      exit if line == ""
      m = line.match(/(\d+)[^\d]+(\d+)/)
      unless m
        puts INVALID_INPUT_MESSAGE
        next
      end
      coords = [m[1].to_i - 1, m[2].to_i - 1]

      unless coords.all? { |e| (0..2).member?(e) }
        puts INVALID_INPUT_MESSAGE
        coords = nil
        next
      end

      unless @board.empty?(coords)
        puts "#{@board.symbol_at(coords)} already placed there!"
        coords = nil
        next
      end
    end

    humanized_coords = [coords[0] + 1, coords[1] + 1]
    puts "Human: Put #{@current_symbol} in #{humanized_coords}"
    @board = @board.mark(coords, @current_symbol)
  end

  def game_tick
    puts
    BoardDrawer.new(@board).draw
    puts


    winner = check_winner
    if winner
      puts "#{winner} just won!"
      exit
    end

    puts "Game: #{@current_symbol}'s turn"

    if humans_turn?
      human_turn
    else
      bot_turn
    end

    @current_symbol = SymbolsManager.other_symbol(@current_symbol)
  end

  def check_winner
    return X if EndgameAnalisys.win?(@board, X)
    return O if EndgameAnalisys.win?(@board, O)
    nil
  end

  def game_loop!
    loop { game_tick }
  end
end
