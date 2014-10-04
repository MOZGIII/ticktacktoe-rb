#!/usr/bin/env ruby
require "./common"

Searcher.set_search_mode! MinMaxSearch

game = Game.new(X)
game.game_loop!
