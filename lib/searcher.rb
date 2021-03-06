module Searcher
  module_function

  def search_mode
    @search_mode
  end

  def set_search_mode!(search_mode)
    raise "Setting search method is only supported once per runtime!" if @search_mode
    @search_mode = search_mode

    # Do the magic!
    ::State.send(:include, @search_mode::StateMixin)
  end

  def search(board, playing_as = X)
    State.reset_search! if State.respond_to?(:reset_search!)
    State.set_playing_as(playing_as)
    action = InitialAction.new(SymbolsManager::other_symbol(playing_as))
    state = State.new(board, action)
    state.init_root_state! if state.respond_to?(:init_root_state!)
    state.max_value_state!
  end
end
