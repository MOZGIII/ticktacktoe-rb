require 'active_support/concern'

module AlphaBetaSearch
  module StateMixin
    extend ActiveSupport::Concern

    class AlphaBetaBox
      attr_accessor :alpha  # overall maximum for max player, nil is -inf
      attr_accessor :beta   # overall minimum for min player, nil is +inf

      def bigger_than_beta?(value) # bigger OR EQUAL
        return false if beta == nil # nil is +inf
        value >= beta
      end
      alias :beta_better_than? :bigger_than_beta?

      def assign_alpha(value)
        # puts "Assigning alpha with #{[alpha, value]}"
        @alpha = [alpha, value].compact.max  # if alpha was nil, than it was -inf
      end


      def smaller_than_alpha?(value)
        return false if alpha == nil # nil is +inf
        value <= alpha
      end
      alias :alpha_better_than? :smaller_than_alpha?

      def assign_beta(value)
        # puts "Assigning beta with #{[beta, value]}"
        @beta = [beta, value].compact.min  # if beta was nil, than it was +inf
      end

      def to_s
        "#<AlphaBetaBox Alpha: #{alpha}, Beta: #{beta}>"
      end
    end

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

      def reset_search!
      end

      def box
      end
    end

    def value
      @value || raise
    end

    def box
      @box || raise
    end

    def init_root_state!
      init_box(AlphaBetaBox.new) # init with infinite box
    end

    def init_box(old_box)
      raise unless old_box
      @box = AlphaBetaBox.new
      @box.alpha, @box.beta = old_box.alpha, old_box.beta
      @box
    end

    def max_value_state!
      if terminal_test?
        @value = self.class.utility(@board)
        return self
      end

      max_child_state = nil
      successors.each do |child_state|
        max_child_state ||= child_state

        # Resolve values for all child state's successors
        child_state.init_box(box)
        child_state.min_value_state!

        # Update max_child_state if needed
        max_child_state = get_by_value(:max, [max_child_state, child_state])

        # Force the value of the current state to be the same as the value in the max_child_state
        @value = max_child_state.value

        # Cut calculations by returning immediately if beta is better than the current value
        return max_child_state if box.beta_better_than?(@value)

        # Else update alpha value for later use
        box.assign_alpha(@value)
      end
      max_child_state
    end

    def min_value_state!
      if terminal_test?
        @value = self.class.utility(@board)
        return self
      end

      min_child_state = nil
      successors.each do |child_state|
        min_child_state ||= child_state

        # Resolve values for all child state's successors
        child_state.init_box(box)
        child_state.max_value_state!

        # Update min_child_state if needed
        min_child_state = get_by_value(:min, [min_child_state, child_state])

        # Force the value of the current state to be the same as the value in the min_child_state
        @value = min_child_state.value

        # Cut calculations by returning immediately if alpha is better than the current value
        return min_child_state if box.alpha_better_than?(@value)

        # Else update beta value for later use
        box.assign_beta(@value)
      end
      min_child_state
    end

    def get_by_value(meth, arr)
      arr.send(meth) { |a, b| a.value <=> b.value }
    end
  end
end
