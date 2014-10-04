#!/usr/bin/env ruby
require "./common"

Searcher.set_search_mode! AlphaBetaSearch

game = Game.new(O)
game.game_loop!
