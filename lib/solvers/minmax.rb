require 'active_support/concern'

module MinMaxSearch
  module StateMixin
    extend ActiveSupport::Concern

    module ClassMethods
      def max_symbol
        @max_symbol
      end

      def min_symbol
        @min_symbol
      end

      def utility(board)
        return  1 if EndgameAnalisys.win?(board, max_symbol) # win
        return -1 if EndgameAnalisys.win?(board, min_symbol) # loss
        0 # tie
      end

      def set_playing_as(symbol)
        @max_symbol = symbol
        @min_symbol = SymbolsManager::other_symbol(symbol)
      end
    end

    def value
      @value || raise
    end

    def max_value_state!
      if terminal_test?
        @value = self.class.utility(@board)
        return self
      end

      s = successors
      s.each do |s|
        s.min_value_state!
      end

      state = s.max { |a, b| a.value <=> b.value }
      @value = state.value
      state
    end

    def min_value_state!
      if terminal_test?
        @value = self.class.utility(@board)
        return self
      end

      s = successors
      s.each do |s|
        s.max_value_state!
      end

      state = s.min { |a, b| a.value <=> b.value }
      @value = state.value
      state
    end
  end
end
