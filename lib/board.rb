#
#      0   1   2
#    +---+---+---+
#  0 |   |   | X |
#    +---+---+---+
#  1 | X |   |   |
#    +---+---+---+
#  2 | X | O | O |
#    +---+---+---+
#

class Board
  SQRT_SIZE = 3
  SIZE = SQRT_SIZE * SQRT_SIZE # 9 cells total

  def initialize(board = nil)
    @board = board || {}
  end

  def mark!(cell, symbol)
    raise ArgumentError, "Invalid symbol #{symbol} passed!" unless symbol_valid?(symbol)
    cell = sanitize_cell(cell)
    @board[cell] = symbol
    self
  end

  def mark(cell, symbol)
    self.class.new(@board.dup).mark!(cell, symbol)
  end

  def symbol_at(cell)
    cell = sanitize_cell(cell)
    @board[cell]
  end

  def empty?(cell)
    !symbol_at(cell)
  end

  def display
    buffer = ""
    SIZE.times do |i|
      pixel = "#"

      val = @board[i]
      pixel = val.to_s if val

      buffer << pixel

      buffer << "\n" if (i+1) % SQRT_SIZE == 0
    end
    buffer
  end

  def filled?
    @board.size == SIZE
  end

private

  def symbol_valid?(symbol)
    SymbolsManager::VALID_SYMBOLS.member?(symbol)
  end

  def sanitize_cell(cell)
    case cell
    when Numeric
      raise ArgumentError, "Cell must be a value from 0 to #{SIZE}!" unless (0...SIZE).member?(cell)
      cell
    when Array
      msg = "Cell must be an array of two elements in 0..2!"
      raise ArgumentError, msg unless cell.size == 2
      x, y = cell
      raise ArgumentError, msg unless (0...SQRT_SIZE).member?(x) && (0...SQRT_SIZE).member?(y)
      y * SQRT_SIZE + x
    else
      raise ArgumentError, "Cell must be an int in 0..#{SIZE-1} or an array of two values in 0..#{SQRT_SIZE-1}!"
    end
  end
end
