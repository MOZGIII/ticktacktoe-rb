class State
  attr_reader :board, :action

  def initialize(board, action)
    @board = board
    @action = action
  end

  def successors
    @successors ||= begin
      value = []
      each_successor do |state|
        value << state
      end
      value
    end
  end

  def each_successor
    @board.class::SIZE.times do |i|
      next unless @board.empty?(i)
      new_state = next_state(i)
      yield new_state
    end
  end

  def terminal_test?
    @board.filled? || EndgameAnalisys.win?(@board, X) || EndgameAnalisys.win?(@board, O)
  end

protected

  def next_state(chosen_position)
    new_action = Action.new(chosen_position, SymbolsManager::other_symbol(@action.s))
    new_board = @board.mark(new_action.p, new_action.s)
    self.class.new(new_board, new_action)
  end
end
