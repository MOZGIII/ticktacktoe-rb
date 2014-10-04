module SymbolsManager
  # Define common symbols here
  X = BoardSymbol.new("X")
  O = BoardSymbol.new("O")

  # Define valid symbols here
  VALID_SYMBOLS = [X, O]

  module QuickAccess
    X, O = X, O
  end

  module_function

  def other_symbol(symbol)
    case symbol
    when X
      O
    when O
      X
    else
      raise "Unknown symbol #{symbol}!"
    end
  end
end

include SymbolsManager::QuickAccess
