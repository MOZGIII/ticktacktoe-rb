module EndgameAnalisys
  module_function

  def win?(board, symbol)
    each_win_pattern do |pattern|
      return true if pattern_matched?(board, pattern, symbol)
    end
    false
  end

  def pattern_matched?(board, pattern, symbol)
    pattern.size.times do |i|
      next unless pattern[i]
      return false if board.symbol_at(i) != symbol
    end
    true
  end

  def each_win_pattern
    t = true
    n = nil

    # Horizontal

    yield [
      t, t, t,
      n, n, n,
      n, n, n,
    ]

    yield [
      n, n, n,
      t, t, t,
      n, n, n,
    ]

    yield [
      n, n, n,
      n, n, n,
      t, t, t,
    ]

    # Vertical

    yield [
      t, n, n,
      t, n, n,
      t, n, n,
    ]

    yield [
      n, t, n,
      n, t, n,
      n, t, n,
    ]

    yield [
      n, n, t,
      n, n, t,
      n, n, t,
    ]

    # Diagonal

    yield [
      t, n, n,
      n, t, n,
      n, n, t,
    ]

    yield [
      n, n, t,
      n, t, n,
      t, n, n,
    ]
  end
end
